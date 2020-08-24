package hxdoom.core;

import haxe.ds.Vector;
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
	
	var lastKeyLumpMarkerRead:KeyLump;
	
	//Jump to a specific registered lump by lump name
	var directory_name_map:Map<String, Array<Directory>>;
	//Jump to a specific registered lump by wadname and directory index
	var directory_index_map:Map<String, Array<Directory>>;
	//Raw per wad data as integers
	var wad_data_map:Map<String, Array<Int>>;
	
	public function new() 
	{
		directory_name_map = new Map();
		directory_index_map = new Map();
		wad_data_map = new Map();
	}
	public function addWadFromString(_data:String, _wadName:String) {
		
		if (!CVarCore.getCvar(Defaults.ALLOW_PWADS) && iwadLoaded) return;
		
		var isIwad:Bool = _data.substr(0, 4) == "IWAD";
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
			data.push(_data.charCodeAt(a));
		}
		wad_data_map[_wadName] = data;
		
		parseWad(_wadName);
		
	}
	
	public function addWadFromBytes(_data:Bytes, _wadName:String) {
		
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
		
		parseWad(_wadName);
	}
	
	public function parseWad(_wadName:String) {
		var directory_count = Reader.getFourBytes(wad_data_map[_wadName], 0x04);
		var directory_offset = Reader.getFourBytes(wad_data_map[_wadName], 0x08);
		
		for (index in 0...directory_count) {
			
			var dir = Reader.readDirectory(wad_data_map[_wadName], directory_offset + index * Directory.BYTE_SIZE, _wadName, index);
			
			directory_index_map[_wadName][index] = dir;
			
			var lumpType = Reader.getLumpType(dir);
			
			switch (lumpType) {
				case KeyLump.LINEDEFS | KeyLump.NODES | KeyLump.SEGS | KeyLump.SIDEDEFS | KeyLump.SECTORS | KeyLump.SSECTORS | KeyLump.THINGS | KeyLump.VERTEXES | KeyLump.REJECT | KeyLump.BLOCKMAP :
					continue;
				case KeyLump.P_START | KeyLump.P1_START | KeyLump.P2_START | KeyLump.P_END | KeyLump.P1_END | KeyLump.P2_END | KeyLump.F_START | KeyLump.F1_START | KeyLump.F2_START | KeyLump.F_END | KeyLump.F1_END | KeyLump.F2_END :
					lastKeyLumpMarkerRead = lumpType;
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
	
	public function getGeneralDir(_name:String, _index:Int = 0) {
		return directory_name_map[_name.toUpperCase()][_index];
	}
	
	public function getWadSpecificDir(_wad:String, _index:Int) {
		return directory_index_map[_wad][_index];
	}
	
	public function getWadByteArray(_name:String) {
		return wad_data_map[_name];
	}
	
	public function wadContains(_lumps:Array<String>):Bool {
		var verified:Bool = true;
		for (name in _lumps) {
			if (directory_name_map[name.toUpperCase()] == null) {
				Engine.log('Lump $name does not exist');
				verified = false;
			}
		}
		return(verified);
	}
}