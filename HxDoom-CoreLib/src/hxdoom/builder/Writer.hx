package hxdoom.builder;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesData;
import hxdoom.enums.eng.KeyLump;
import hxdoom.Engine;
import hxdoom.component.LevelMap;

/**
 * ...
 * @author Kaelan
 */
class Writer 
{
	
	
	public function new() 
	{
		
	}
	
	public function compile(_iwad:Bool = false) {
		
	}
	
	public inline function toEightCharBytes(_name:String):Bytes {
		var str:String = _name;
		if (str.length > 8) {
			str = str.substr(0, 8);
		}
		while (str.length != 8) {
			str += String.fromCharCode(0);
		}
		return Bytes.ofString(str);
	}
	public inline function toInt32Bytes(_int:Int):Bytes {
		var bytes = Bytes.alloc(4);
		bytes.setInt32(0, _int);
		return bytes;
	}
	public inline function toInt16Bytes(_int:Int):Bytes {
		var bytes = Bytes.alloc(2);
		bytes.setUInt16(0, _int);
		return bytes;
	}
}