package hxdoom.core;

import haxe.io.Bytes;

import hxdoom.core.Reader;
import hxdoom.lumps.Directory;
import hxdoom.lumps.graphic.*;
import hxdoom.enums.eng.KeyLump;
import hxdoom.enums.eng.DataLump;
import hxdoom.enums.data.Defaults;

/**
 * ...
 * @author Kaelan
 */
class WadCore 
{
	var iwadLoaded:Bool = false;
	
	//Jump to a specific registered lump by lump name
	public var directory_name_map:Map<String, Array<Directory>>;
	//Jump to a specific registered lump by wadname and directory index
	public var directory_index_map:Map<String, Array<Directory>>;
	//Raw per wad data as integers
	public var wad_data_map:Map<String, Array<Int>>;
	
	public var playpal:Playpal;
	
	public function new() 
	{
		directory_name_map = new Map();
		directory_index_map = new Map();
		wad_data_map = new Map();
	}
	
	public function addWad(_data:Bytes, _wadName:String) {
		
		if (!CVarCore.getCvar(Defaults.ALLOW_PWADS) && iwadLoaded) return;
		
		var isIwad:Bool = _data.getString(0, 4) == "IWAD";
		if (isIwad) {
			if (iwadLoaded) {
				if (!CVarCore.getCvar(Defaults.ALLOW_MULTIPLE_IWADS)) return;
			} else {
				iwadLoaded = true;
			}
		}
		
		directory_index_map[_wadName] = new Array();
		
		var data = new Array();
		for (a in 0..._data.length) {
			data.push(_data.get(a));
		}
		wad_data_map[_wadName] = data;
		
		var directory_count = Reader.getFourBytes(wad_data_map[_wadName], 0x04);
		var directory_offset = Reader.getFourBytes(wad_data_map[_wadName], 0x08);
		
		for (index in 0...directory_count) {
			
			var dir = Reader.readDirectory(wad_data_map[_wadName], directory_offset + index * 16, _wadName, index);
			
			directory_index_map[_wadName][index] = dir;
			
			var lumpType = Reader.checkLumpType(dir);
			
			switch (lumpType) {
				case KeyLump.LINEDEFS | KeyLump.NODES | KeyLump.SEGS | KeyLump.SIDEDEFS | KeyLump.SECTORS | KeyLump.SSECTORS | KeyLump.THINGS | KeyLump.VERTEXES | KeyLump.REJECT | KeyLump.BLOCKMAP :
					continue;
				default :
					
			}
			
			indexLump(dir);
		}
		
		
		CVarCore.setCVar(Defaults.WADS_LOADED, true);
	}
	
	public function indexLump(_dir:Directory) {
		if (directory_name_map[_dir.name] == null) {
			directory_name_map[_dir.name] = new Array();
			directory_name_map[_dir.name][0] = _dir;
		} else {
			directory_name_map[_dir.name].unshift(_dir);
		}
	}
	
	public function getPatch(_patchName:String):Patch {
		var dir = directory_name_map[_patchName][0];
		var patch = Reader.readPatch(wad_data_map[dir.wad], dir.dataOffset);
		return patch;
	}
	
	public function wadContains(_lumps:Array<String>):Bool {
		var verified:Bool = true;
		for (name in _lumps) {
			if (directory_name_map[name] == null) {
				Engine.log('Lump $name does not exist');
				verified = false;
			}
		}
		return(verified);
	}
	
	public function loadPlaypal() {
		
		var directory = directory_name_map[KeyLump.PLAYPAL][0];
		
		playpal = new Playpal();
		
		var numPals:Int = Std.int(directory.size / 768);
		var offset:Int = 0;
		for (pal in 0...numPals) {
			for (sw in 0...256) {
				
				var red:Int = Reader.getOneByte(wad_data_map[directory.wad], directory.dataOffset + offset);
				var green:Int = Reader.getOneByte(wad_data_map[directory.wad], directory.dataOffset + (offset += 1));
				var blue:Int = Reader.getOneByte(wad_data_map[directory.wad], directory.dataOffset + (offset += 1));
				
				var _color:Int = (red << 16) | (green << 8) | blue;
				
				playpal.addSwatch(pal, _color);
				
				offset += 1;
			}
		}
		
	}
	
	public function loadMap(_mapMarker:String):Bool {
		
		if (!wadContains([_mapMarker])) {
			return false;
		}
		
		var place:Int = 0;
		var numitems:Int = 0;
		
		var _map = new BSPMap();
		var directory:Directory = directory_name_map[_mapMarker][0];
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load things
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directory_index_map[directory.wad][directory.index + 1].name != hxdoom.enums.eng.KeyLump.THINGS) {
			Engine.log("Map data corrupt: Expected Things, found: " + directory_index_map[directory.wad][directory.index + 1].name);
			return false;
		}
		numitems = Std.int(directory_index_map[directory.wad][directory.index + 1].size / Reader.THING_LUMP_SIZE);
		place = directory_index_map[directory.wad][directory.index + 1].dataOffset;
		for (a in 0...numitems) {
			_map.things[a] = Reader.readThing(wad_data_map[directory.wad], place + a * Reader.THING_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load linedefs
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directory_index_map[directory.wad][directory.index + 2].name != hxdoom.enums.eng.KeyLump.LINEDEFS) {
			Engine.log("Map data corrupt: Expected Linedefss, found: " + directory_index_map[directory.wad][directory.index + 2].name);
			return false;
		}
		numitems = Std.int(directory_index_map[directory.wad][directory.index + 2].size / Reader.LINEDEF_LUMP_SIZE);
		place = directory_index_map[directory.wad][directory.index + 2].dataOffset;
		for (a in 0...numitems) {
			_map.linedefs[a] = Reader.readLinedef(wad_data_map[directory.wad], place + a * Reader.LINEDEF_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load sidedefs
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directory_index_map[directory.wad][directory.index + 3].name != hxdoom.enums.eng.KeyLump.SIDEDEFS) {
			Engine.log("Map data corrupt: Expected Sidedefs, found: " + directory_index_map[directory.wad][directory.index + 3].name);
			return false;
		}
		numitems = Std.int(directory_index_map[directory.wad][directory.index + 3].size / Reader.SIDEDEF_LUMP_SIZE);
		place = directory_index_map[directory.wad][directory.index + 3].dataOffset;
		for (a in 0...numitems) {
			_map.sidedefs[a] = Reader.readSideDef(wad_data_map[directory.wad], place + a * Reader.SIDEDEF_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load vertexes
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directory_index_map[directory.wad][directory.index + 4].name != hxdoom.enums.eng.KeyLump.VERTEXES) {
			Engine.log("Map data corrupt: Expected Vertexes, found: " + directory_index_map[directory.wad][directory.index + 4].name);
			return false;
		}
		numitems = Std.int(directory_index_map[directory.wad][directory.index + 4].size / Reader.VERTEX_LUMP_SIZE);
		place = directory_index_map[directory.wad][directory.index + 4].dataOffset;
		for (a in 0...numitems) {
			_map.vertexes[a] = Reader.readVertex(wad_data_map[directory.wad], place + a * Reader.VERTEX_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load segments
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directory_index_map[directory.wad][directory.index + 5].name != hxdoom.enums.eng.KeyLump.SEGS) {
			Engine.log("Map data corrupt: Expected Segments, found: " + directory_index_map[directory.wad][directory.index + 5].name);
			return false;
		}
		numitems = Std.int(directory_index_map[directory.wad][directory.index + 5].size / Reader.SEG_LUMP_SIZE);
		place = directory_index_map[directory.wad][directory.index + 5].dataOffset;
		for (a in 0...numitems) {
			_map.segments[a] = Reader.readSegment(wad_data_map[directory.wad], place + a * Reader.SEG_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load Subsectors
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directory_index_map[directory.wad][directory.index + 6].name != hxdoom.enums.eng.KeyLump.SSECTORS) {
			Engine.log("Map data corrupt: Expected Subsectors, found: " + directory_index_map[directory.wad][directory.index + 6].name);
			return false;
		}
		numitems = Std.int(directory_index_map[directory.wad][directory.index + 6].size / Reader.SSECTOR_LUMP_SIZE);
		place = directory_index_map[directory.wad][directory.index + 6].dataOffset;
		for (a in 0...numitems) {
			_map.subsectors[a] = Reader.readSubSector(wad_data_map[directory.wad], place + a * Reader.SSECTOR_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load nodes
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directory_index_map[directory.wad][directory.index + 7].name != hxdoom.enums.eng.KeyLump.NODES) {
			Engine.log("Map data corrupt: Expected Nodes, found: " + directory_index_map[directory.wad][directory.index + 7].name);
			return false;
		}
		numitems = Std.int(directory_index_map[directory.wad][directory.index + 7].size / Reader.NODE_LUMP_SIZE);
		place = directory_index_map[directory.wad][directory.index + 7].dataOffset;
		for (a in 0...numitems) {
			_map.nodes[a] = Reader.readNode(wad_data_map[directory.wad], place + a * Reader.NODE_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load sectors
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directory_index_map[directory.wad][directory.index + 8].name != hxdoom.enums.eng.KeyLump.SECTORS) {
			Engine.log("Map data corrupt: Expected Sectors, found: " + directory_index_map[directory.wad][directory.index + 8].name);
			return false;
		}
		numitems = Std.int(directory_index_map[directory.wad][directory.index + 8].size / Reader.SECTOR_LUMP_SIZE);
		place = directory_index_map[directory.wad][directory.index + 8].dataOffset;
		for (a in 0...numitems) {
			_map.sectors[a] = Reader.readSector(wad_data_map[directory.wad], place + a * Reader.SECTOR_LUMP_SIZE);
		}
		
		//Map name as stated in WAD, IE E#M#/MAP##
		_map.name = directory_index_map[directory.wad][directory.index].name;
		
		Engine.ACTIVEMAP = _map;
		Engine.ACTIVEMAP.parseThings();
		Engine.ACTIVEMAP.setOffset();
		
		return true;
	}
}