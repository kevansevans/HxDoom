package hxdoom.core;

import hxdoom.lumps.Directory;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Node;
import hxdoom.lumps.map.Sector;
import hxdoom.lumps.map.Segment;
import hxdoom.lumps.map.SideDef;
import hxdoom.lumps.map.SubSector;
import hxdoom.lumps.map.Thing;
import hxdoom.lumps.map.Vertex;

/**
 * ...
 * @author Kaelan
 */
class Reader 
{
	public static inline var VERTEX_LUMP_SIZE:Int = 4;
	public static inline var LINEDEF_LUMP_SIZE:Int = 14;
	public static inline var THING_LUMP_SIZE:Int = 10;
	public static inline var NODE_LUMP_SIZE:Int = 28;
	public static inline var SSECTOR_LUMP_SIZE:Int = 4;
	public static inline var SEG_LUMP_SIZE:Int = 12;
	public static inline var SIDEDEF_LUMP_SIZE:Int = 30;
	public static inline var SECTOR_LUMP_SIZE:Int = 26;
	
	public function new() { }
	
	public static inline function readDirectory(_data:Array<Int>, _offset:Int, _wadname:String, _index:Int):Directory {
		return new Directory(
			getFourBytes(_data, _offset),
			getFourBytes(_data, _offset + 0x04),
			getStringFromRange(_data, _offset + 0x08, _offset + 0x10),
			_wadname,
			_index
		);
	}
	
	public static inline function readThing(_data:Array<Int>, _offset:Int):Thing {
		return new Thing(
			getTwoBytes(_data, _offset, true),
			getTwoBytes(_data, _offset + 2, true),
			getTwoBytes(_data, _offset + 4, true),
			getTwoBytes(_data, _offset + 6, true),
			getTwoBytes(_data, _offset + 8, true)
		);
	}
	
	public static inline function readLinedef(_data:Array<Int>, _offset:Int):LineDef {
		return new LineDef(
			getTwoBytes(_data, _offset),
			getTwoBytes(_data, _offset + 2),
			getTwoBytes(_data, _offset + 4),
			getTwoBytes(_data, _offset + 6),
			getTwoBytes(_data, _offset + 8),
			getTwoBytes(_data, _offset + 10),
			getTwoBytes(_data, _offset + 12)
		);
	}
	
	public static inline function readVertex(_data:Array<Int>, _offset:Int):Vertex {
		return new Vertex(
			getTwoBytes(_data, _offset, true),
			getTwoBytes(_data, _offset + 2, true)
		);
	}
	
	public static inline function readSegment(_data:Array<Int>, _offset:Int):Segment {
		return new Segment(
			getTwoBytes(_data, _offset + 4, true),
			getTwoBytes(_data, _offset + 6),
			getTwoBytes(_data, _offset + 8),
			getTwoBytes(_data, _offset + 10)
		);
	}
	
	public static inline function readSubSector(_data:Array<Int>, _offset:Int):SubSector {
		return new SubSector(
			getTwoBytes(_data, _offset),
			getTwoBytes(_data, _offset + 2)
		);
	}
	
	public static inline function readNode(_data:Array<Int>, _offset:Int):Node {
		return new Node(
			getTwoBytes(_data, _offset, true),
			getTwoBytes(_data, _offset + 2, true),
			getTwoBytes(_data, _offset + 4, true),
			getTwoBytes(_data, _offset + 6, true),
			getTwoBytes(_data, _offset + 8, true),
			getTwoBytes(_data, _offset + 10, true),
			getTwoBytes(_data, _offset + 12, true),
			getTwoBytes(_data, _offset + 14, true),
			getTwoBytes(_data, _offset + 16, true),
			getTwoBytes(_data, _offset + 18, true),
			getTwoBytes(_data, _offset + 20, true),
			getTwoBytes(_data, _offset + 22, true),
			getTwoBytes(_data, _offset + 24),
			getTwoBytes(_data, _offset + 26)
		);
	}
	
	public static inline function readSideDef(_data:Array<Int>, _offset:Int):SideDef {
		return new SideDef(
			getTwoBytes(_data, _offset, true),
			getTwoBytes(_data, _offset + 2, true),
			getStringFromRange(_data, _offset + 4, _offset + 12),
			getStringFromRange(_data, _offset + 12, _offset + 20),
			getStringFromRange(_data, _offset + 20, _offset + 28),
			getTwoBytes(_data, _offset + 28)
		);
	}
	
	public static inline function readSector(_data:Array<Int>, _offset:Int):Sector {
		return new Sector(
			getTwoBytes(_data, _offset, true),
			getTwoBytes(_data, _offset + 2, true),
			getStringFromRange(_data, _offset + 4, _offset + 12),
			getStringFromRange(_data, _offset + 12, _offset + 20),
			getTwoBytes(_data, _offset + 20, true),
			getTwoBytes(_data, _offset + 22),
			getTwoBytes(_data, _offset + 24)
		);
	}
	/**
	 * Get an 8 bit value from provided data and location
	 * @param	_data Data of current wad loaded
	 * @param	_offset Position of data needed
	 * @param	_signed Is value an signed value?
	 * @return Returns an integer from specified position
	 */
	public static inline function getOneByte(_data:Array<Int>, _offset:Int, _signed:Bool = false):Int {
		var val = _data[_offset];
		return(_signed == true && val > 127 ? val - 255 : val);
	}
	/**
	 * Get an 16 bit value (Short) from provided data and location
	 * @param	_data
	 * @param	_offset
	 * @param	_signed
	 * @return
	 */
	public static inline function getTwoBytes(_data:Array<Int>, _offset:Int, _signed:Bool = false):Int //16 bits
	{
		var val = (_data[_offset + 1] << 8) | _data[_offset];
		return(_signed == true && val > 32768 ? val - 65536 : val);
	}
	/**
	 * Get a 32 bit bit value (Long) from provided data and location
	 * @param	_data Data of current wad loaded
	 * @param	_offset Position of data needed
	 * @return Returns an integer from specified position
	 */
	public static inline function getFourBytes(_data:Array<Int>, _offset:Int):Int {
		return((_data[_offset + 3] << 24) | (_data[_offset + 2] << 16) | (_data[_offset + 1] << 8) | _data[_offset]);
	}
	/**
	 * Get and construct a string value from specified range 
	 * @param	_data Data of current wad loaded
	 * @param	_start Start position of string
	 * @param	_end End position of string
	 * @return	Returns a UTF8 compatible string. Automatically removes null and empty characters.
	 */
	public static inline function getStringFromRange(_data:Array<Int>, _start:Int, _end:Int):String {
		var str:String = "";
		for (a in _start..._end) {
			if (_data[a] != 0 && Math.isNaN(_data[a]) == false) str += String.fromCharCode(_data[a]);
		}
		return str;
	}
	/*public static inline function getMidi(_data:Array<Int>, _offset:Int, _size:Int) {
		for (byte in _offset..._offset(_offset + _size)) {
			
		}
	}*/
}