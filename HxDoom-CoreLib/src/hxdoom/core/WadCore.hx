package hxdoom.core;

import haxe.ds.Vector;
import haxe.io.Bytes;

import hxdoom.core.Reader;
import hxdoom.lumps.Directory;
import hxdoom.enums.eng.KeyLump;
import hxdoom.enums.data.Defaults;

/**
 * ...
 * @author Kaelan
 */
class WadCore 
{
	var iwadLoaded:Bool = false;
	
	var lastKeyLumpMarkerRead:KeyLump;
	
	
	public var directoryList:Map<String, Array<Directory>>;
	public var wadDirectoryName:Map<String, Map<String, Directory>>;
	public var wadDirectoryIndex:Map<String, Array<Directory>>;
	public var wadDataSet:Map<String, Array<Int>>;
	
	public function new() 
	{
		directoryList = new Map();
		wadDirectoryName = new Map();
		wadDirectoryIndex = new Map();
		wadDataSet = new Map();
	}
	public function addWadFromString(_data:String, _wadName:String) {
		
		if (!CVarCore.getCvar(Defaults.ALLOW_PWADS) && iwadLoaded) return;
		
		var isIwad:Bool = _data.substr(0, 4) == "IWAD";
		if (isIwad) {
			if (iwadLoaded) {
				if (!CVarCore.getCvar(Defaults.ALLOW_MULTIPLE_IWADS)) {
					Engine.log(['Multiple IWADS are not allowed, $_wadName was not loaded', 'Please set the cvar ' + Defaults.ALLOW_MULTIPLE_IWADS + ' to true']);
					return;
				}
			} else {
				iwadLoaded = true;
			}
		}
		
		wadDirectoryName[_wadName] = new Map();
		wadDirectoryIndex[_wadName] = new Array();
		
		var data = new Array();
		for (a in 0..._data.length) {
			data.push(_data.charCodeAt(a));
		}
		wadDataSet[_wadName] = data;
		
		parseWad(_wadName);
		
	}
	
	public function addWadFromBytes(_data:Bytes, _wadName:String) {
		
		if (!CVarCore.getCvar(Defaults.ALLOW_PWADS) && iwadLoaded) return;
		
		var isIwad:Bool = _data.getString(0, 4) == "IWAD";
		if (isIwad) {
			if (iwadLoaded) {
				if (!CVarCore.getCvar(Defaults.ALLOW_MULTIPLE_IWADS)) {
					Engine.log(['Multiple IWADS are not allowed, $_wadName was not loaded', 'Please set the cvar ' + Defaults.ALLOW_MULTIPLE_IWADS + ' to true']);
					return;
				}
			} else {
				iwadLoaded = true;
			}
		}
		
		wadDirectoryName[_wadName] = new Map();
		wadDirectoryIndex[_wadName] = new Array();
		
		var data = new Array();
		for (a in 0..._data.length) {
			data.push(_data.get(a));
		}
		wadDataSet[_wadName] = data;
		
		parseWad(_wadName);
	}
	
	public function parseWad(_wadName:String) {
		var directory_count = Reader.getFourBytes(wadDataSet[_wadName], 0x04);
		var directory_offset = Reader.getFourBytes(wadDataSet[_wadName], 0x08);
		
		for (index in 0...directory_count) {
			
			var dir = Reader.readDirectory(wadDataSet[_wadName], directory_offset + index * Directory.BYTE_SIZE, _wadName, index);
			
			wadDirectoryName[_wadName][dir.name] = dir;
			wadDirectoryIndex[_wadName].push(dir);
			
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
		if (directoryList[_dir.name] == null) {
			directoryList[_dir.name] = new Array();
			directoryList[_dir.name][0] = _dir;
		} else {
			directoryList[_dir.name].unshift(_dir);
		}
	}
	
	public function getDirectory(_name:String, _index:Int = 0) {
		return directoryList[_name.toUpperCase()][_index];
	}
	
	public function getIndexSpecificDir(_wad:String, index:Int):Directory {
		return wadDirectoryIndex[_wad][index];
	}
	public function getWadSpecificDir(_wad:String, _name:String):Directory {
		return wadDirectoryName[_wad][_name];
	}
	
	public function getWadByteArray(_name:String) {
		return wadDataSet[_name];
	}
	
	public function wadContains(_lumps:Array<String>):Bool {
		var verified:Bool = true;
		for (name in _lumps) {
			if (directoryList[name.toUpperCase()] == null) {
				Engine.log(['Lump $name does not exist']);
				verified = false;
			}
		}
		return(verified);
	}
}