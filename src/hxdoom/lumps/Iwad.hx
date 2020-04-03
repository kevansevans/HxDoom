package hxdoom.lumps;

import haxe.ds.Map;
import haxe.PosInfos;
import haxe.io.Bytes;
import hxdoom.core.Reader;
import hxdoom.enums.Lump;
import hxdoom.lumps.graphic.Playpal;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Segment;
import hxdoom.lumps.map.Vertex;
import hxdoom.lumps.map.Thing;

import hxdoom.common.Conversions;
import hxdoom.common.Environment;

import hxdoom.lumps.Directory;
import hxdoom.core.BSPMap;

/**
 * ...
 * @author Kaelan
 * 
 * To reduce typing redundancy, I named this class "pack" to represent the wad data as a whole.
 */
class Iwad 
{
	//public static var SPRITELIST:Map<String, some class here> = new Map(); 
	var data:Array<Int>;
	var wadname:String;
	
	public var directories:Array<Directory>;
	public var lumpPointers:Map<String, Directory>;
	var directory_count:Int;
	var directory_offset:Int;
	
	public var playpal:Playpal;
	
	/**
	 * Currently loaded map
	 */
	public var activeMap:BSPMap;
	/**
	 * Getter to retrieve active map's vertexes
	 */
	public var vertexes(get, null):Array<Vertex>;
	/**
	 * Getter to retrieve active map's linedefs
	 */
	public var linedefs(get, null):Array<LineDef>;
	/**
	 * Getter to retrieve active map's things
	 */
	public var things(get, null):Array<Thing>;
	/**
	 * Getter to retrieve segments
	 */
	public var segments(get, null):Array<Segment>;
	
	/**
	 * Constructor for new WAD
	 * 
	 * @param	_data Haxe.io.bytes, gets converted into int Array for JS friendliness
	 * @param	_name String denoting file name to prevent overlapping
	 * @param	_iwad Is this wad an IWAD?
	 */
	public function new(_data:Bytes, _name:String) 
	{
		data = new Array();
		for (a in 0..._data.length) {
			data.push(_data.get(a));
		}
		
		wadname = _name;
		
		loadDirectories();
	}
	function loadDirectories() {
		directory_count = Reader.getFourBytes(data, 0x04);
		directory_offset = Reader.getFourBytes(data, 0x08);
		
		directories = new Array();
		for (index in 0...directory_count) {
			directories[index] = Reader.readDirectory(data, directory_offset + index * 16);
			directories[index].listIndex = index;
		}
		
		lumpPointers = new Map();
		
		for (dir in directories) {
			lumpPointers[dir.name] = dir;
			
			//load lumps that are global
			switch (dir.name) {
				case "PLAYPAL" :
					loadPlaypal(lumpPointers[dir.name]);
				default :
					
			}
		}
	}
	/**
	 * Loads in and sets 'activeMap' the specified map
	 * @param	_index map index
	 */
	public function loadMap(_index:Int):Bool {
		var mapname = Conversions.levelIntToLevelString(_index);
		if (mapname == "NaM") {
			Engine.log("Not a Map");
			return false;
		}
		
		var place:Int = 0;
		var numitems:Int = 0;
		
		var _map = new BSPMap();
		var _offset = lumpPointers[mapname].listIndex;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load nodes
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directories[_offset + 7].name != Lump.NODES) {
			Engine.log("Map data corrupt: Expected Nodes, found: " + directories[_offset + 7].name);
			return false;
		}
		numitems = Std.int(directories[_offset + 7].size / Reader.NODE_LUMP_SIZE);
		place = directories[_offset + 7].dataOffset;
		for (a in 0...numitems) {
			_map.nodes[a] = Reader.readNode(data, place + a * Reader.NODE_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load vertexes
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directories[_offset + 4].name != Lump.VERTEXES) {
			Engine.log("Map data corrupt: Expected Vertexes, found: " + directories[_offset + 4].name);
			return false;
		}
		numitems = Std.int(directories[_offset + 4].size / Reader.VERTEX_LUMP_SIZE);
		place = directories[_offset + 4].dataOffset;
		for (a in 0...numitems) {
			_map.vertexes[a] = Reader.readVertex(data, place + a * Reader.VERTEX_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load things
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directories[_offset + 1].name != Lump.THINGS) {
			Engine.log("Map data corrupt: Expected Things, found: " + directories[_offset + 1].name);
			return false;
		}
		numitems = Std.int(directories[_offset + 1].size / Reader.THING_LUMP_SIZE);
		place = directories[_offset + 1].dataOffset;
		for (a in 0...numitems) {
			_map.things[a] = Reader.readThing(data, place + a * Reader.THING_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load sectors
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directories[_offset + 8].name != Lump.SECTORS) {
			Engine.log("Map data corrupt: Expected Sectors, found: " + directories[_offset + 8].name);
			return false;
		}
		numitems = Std.int(directories[_offset + 8].size / Reader.SECTOR_LUMP_SIZE);
		place = directories[_offset + 8].dataOffset;
		for (a in 0...numitems) {
			_map.sectors[a] = Reader.readSector(data, place + a * Reader.SECTOR_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load sidedefs
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directories[_offset + 3].name != Lump.SIDEDEFS) {
			Engine.log("Map data corrupt: Expected Sidedefs, found: " + directories[_offset + 3].name);
			return false;
		}
		numitems = Std.int(directories[_offset + 3].size / Reader.SIDEDEF_LUMP_SIZE);
		place = directories[_offset + 3].dataOffset;
		for (a in 0...numitems) {
			_map.sidedefs[a] = Reader.readSideDef(data, place + a * Reader.SIDEDEF_LUMP_SIZE, _map.sectors);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load linedefs
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directories[_offset + 2].name != Lump.LINEDEFS) {
			Engine.log("Map data corrupt: Expected Linedefss, found: " + directories[_offset + 2].name);
			return false;
		}
		numitems = Std.int(directories[_offset + 2].size / Reader.LINEDEF_LUMP_SIZE);
		place = directories[_offset + 2].dataOffset;
		for (a in 0...numitems) {
			_map.linedefs[a] = Reader.readLinedef(data, place + a * Reader.LINEDEF_LUMP_SIZE, _map.vertexes, _map.sidedefs);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load segments
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directories[_offset + 5].name != Lump.SEGS) {
			Engine.log("Map data corrupt: Expected Segments, found: " + directories[_offset + 5].name);
			return false;
		}
		numitems = Std.int(directories[_offset + 5].size / Reader.SEG_LUMP_SIZE);
		place = directories[_offset + 5].dataOffset;
		for (a in 0...numitems) {
			_map.segments[a] = Reader.readSegment(data, place + a * Reader.SEG_LUMP_SIZE, _map.linedefs);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load Subsectors
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (directories[_offset + 6].name != Lump.SSECTORS) {
			Engine.log("Map data corrupt: Expected Subsectors, found: " + directories[_offset + 6].name);
			return false;
		}
		numitems = Std.int(directories[_offset + 6].size / Reader.SSECTOR_LUMP_SIZE);
		place = directories[_offset + 6].dataOffset;
		for (a in 0...numitems) {
			_map.subsectors[a] = Reader.readSubSector(data, place + a * Reader.SSECTOR_LUMP_SIZE, _map.segments);
		}
		
		//Map name as stated in WAD, IE E#M#/MAP##
		_map.name = directories[_offset].name;
		
		Engine.ACTIVEMAP = _map;
		Engine.ACTIVEMAP.parseThings();
		Engine.ACTIVEMAP.setOffset();
		
		return true;
	}
	
	public function loadPlaypal(_dir:Directory) {
		playpal = new Playpal();
		var numPals:Int = Std.int(_dir.size / 768);
		var offset:Int = 0;
		for (pal in 0...numPals) {
			for (sw in 0...256) {
				
				var red:Int = Reader.getOneByte(data, _dir.dataOffset + offset);
				var green:Int = Reader.getOneByte(data, _dir.dataOffset + (offset += 1));
				var blue:Int = Reader.getOneByte(data, _dir.dataOffset + (offset += 1));
				
				var _color:Int = (red << 16) | (green << 8) | blue;
				
				playpal.addSwatch(pal, _color);
				
				offset += 1;
			}
		}
		
		if (Engine.PLAYPAL == null) Engine.PLAYPAL = playpal;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//Getters
	////////////////////////////////////////////////////////////////////////////////////////////////////
	function get_vertexes():Array<Vertex> 
	{
		return activeMap.vertexes;
	}
	
	function get_linedefs():Array<LineDef> 
	{
		return activeMap.linedefs;
	}
	
	function get_things():Array<Thing> 
	{
		return activeMap.things;
	}
	
	function get_segments():Array<Segment> 
	{
		return activeMap.segments;
	}
}