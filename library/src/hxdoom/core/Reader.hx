package hxdoom.core;

import haxe.ds.Vector;
import hxdoom.enums.eng.DataLump;
import hxdoom.enums.eng.KeyLump;
import hxdoom.lumps.Directory;
import hxdoom.lumps.graphic.Patch;
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
	
	public static var keyLumpList:Array<String>;
	public static var dataLumpList:Array<String>;
	
	public function new() { }
	
	/**
	 * Reads from provided data and returns a new directory.
	 * @param	_data
	 * @param	_offset
	 * @param	_wadname
	 * @param	_index
	 * @return
	 */
	public static inline function readDirectory(_data:Array<Int>, _offset:Int, _wadname:String = "", _index:Int = -1):Directory {
		return Directory.CONSTRUCTOR([
			getFourBytes(_data, _offset),
			getFourBytes(_data, _offset + 0x04),
			getStringFromRange(_data, _offset + 0x08, _offset + 0x10),
			_wadname,
			_index
		]);
	}
	/**
	 * Reads from provided data and returns a new Thing
	 * @param	_data
	 * @param	_offset
	 * @return
	 */
	public static inline function readThing(_data:Array<Int>, _offset:Int):Thing {
		return Thing.CONSTRUCTOR([
			getTwoBytes(_data, _offset, true),
			getTwoBytes(_data, _offset + 2, true),
			getTwoBytes(_data, _offset + 4, true),
			getTwoBytes(_data, _offset + 6, true),
			getTwoBytes(_data, _offset + 8, true)
		]);
	}
	/**
	 * Reads from provided data and returns a new Linedef
	 * @param	_data
	 * @param	_offset
	 * @return
	 */
	public static inline function readLinedef(_data:Array<Int>, _offset:Int):LineDef {
		return LineDef.CONSTRUCTOR([
			getTwoBytes(_data, _offset),
			getTwoBytes(_data, _offset + 2),
			getTwoBytes(_data, _offset + 4),
			getTwoBytes(_data, _offset + 6),
			getTwoBytes(_data, _offset + 8),
			getTwoBytes(_data, _offset + 10),
			getTwoBytes(_data, _offset + 12)
		]);
	}
	/**
	 * Reads from provided data and returns a new Vertex
	 * @param	_data
	 * @param	_offset
	 * @return
	 */
	public static inline function readVertex(_data:Array<Int>, _offset:Int):Vertex {
		
		return Vertex.CONSTRUCTOR([
			getTwoBytes(_data, _offset, true), 
			getTwoBytes(_data, _offset + 2, true)
		]);
		
	}
	/**
	 * Reads from provided data and returns a new Segment
	 * @param	_data
	 * @param	_offset
	 * @return
	 */
	public static inline function readSegment(_data:Array<Int>, _offset:Int):Segment {
		return Segment.CONSTRUCTOR([
			getTwoBytes(_data, _offset + 4, true),
			getTwoBytes(_data, _offset + 6),
			getTwoBytes(_data, _offset + 8),
			getTwoBytes(_data, _offset + 10)
		]);
	}
	/**
	 * Reads from provided data and returns a new Subsector
	 * @param	_data
	 * @param	_offset
	 * @return
	 */
	public static inline function readSubSector(_data:Array<Int>, _offset:Int):SubSector {
		return SubSector.CONSTRUCTOR([
			getTwoBytes(_data, _offset),
			getTwoBytes(_data, _offset + 2)
		]);
	}
	/**
	 * Reads from provided data and returns a new Node
	 * @param	_data
	 * @param	_offset
	 * @return
	 */
	public static inline function readNode(_data:Array<Int>, _offset:Int):Node {
		return Node.CONSTRUCTOR([
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
		]);
	}
	/**
	 * Reads from provided data and returns a new Sidedef
	 * @param	_data
	 * @param	_offset
	 * @return
	 */
	public static inline function readSideDef(_data:Array<Int>, _offset:Int):SideDef {
		return SideDef.CONSTRUCTOR([
			getTwoBytes(_data, _offset, true),
			getTwoBytes(_data, _offset + 2, true),
			getStringFromRange(_data, _offset + 4, _offset + 12),
			getStringFromRange(_data, _offset + 12, _offset + 20),
			getStringFromRange(_data, _offset + 20, _offset + 28),
			getTwoBytes(_data, _offset + 28)
		]);
	}
	/**
	 * Reads from provided data and returns a new Sector
	 * @param	_data
	 * @param	_offset
	 * @return
	 */
	public static inline function readSector(_data:Array<Int>, _offset:Int):Sector {
		return Sector.CONSTRUCTOR([
			getTwoBytes(_data, _offset, true),
			getTwoBytes(_data, _offset + 2, true),
			getStringFromRange(_data, _offset + 4, _offset + 12),
			getStringFromRange(_data, _offset + 12, _offset + 20),
			getTwoBytes(_data, _offset + 20, true),
			getTwoBytes(_data, _offset + 22),
			getTwoBytes(_data, _offset + 24)
		]);
	}
	/**
	 * Read data and return a patch from given location
	 * @param	_data Specified wad data array
	 * @param	_offset Location of patch
	 * @return New patch with correct data values
	 *///With thanks to Phantombeta for getting this to work
	public static inline function readPatch(_data:Array<Int>, _offset:Int):Patch {
			
		var patch = Patch.CONSTRUCTOR([
			getTwoBytes(_data, _offset),
			getTwoBytes(_data, _offset + 2),
			getTwoBytes(_data, _offset + 4, true),
			getTwoBytes(_data, _offset + 6, true)
		]);
		
		var columnsOffsets:Vector<Int> = new Vector<Int> (patch.width);
		
		for (w_index in 0...patch.width) {
			var c_offset:Int = getFourBytes(_data, _offset + 8 + (w_index * 4));
			columnsOffsets[w_index] = c_offset;
		}
		
		for (w_index in 0...columnsOffsets.length) {
			if (patch.pixels[w_index] == null) patch.pixels[w_index] = new Vector(patch.height);
			
			for (h in 0...patch.pixels[w_index].length) {
				patch.pixels[w_index][h] = -1;
			}
			
			var c_offset:Int = columnsOffsets[w_index];
			
			var rowStart:Int = 0;
			
			while (rowStart < 255) {
				rowStart = getOneByte(_data, _offset + c_offset);
				
				if (rowStart == 255) break;
				
				var pixelCount:Int = getOneByte(_data, _offset + c_offset + 1);
				c_offset += 3;
				
				for (d_offset in 0...pixelCount) {
					patch.pixels[w_index][rowStart + d_offset] = getOneByte(_data, _offset + c_offset + d_offset);
				}
				c_offset += pixelCount+1;
			}
		}
		
		return patch;
	}
	public static function getLumpType(_dir:Directory, _returnAsLump:Bool = false):Dynamic
	{
		if (keyLumpList.contains(_dir.name)) {
			//These lumps don't need any special methods of identifying them, as their name is a direct indicator of their use and behavior
			return _dir.name;
		}
		
		var offset = _dir.dataOffset;
		var data = Engine.WADDATA.getWadByteArray(_dir.wad);
		
		//soundcard sounds
		var three:Int = getTwoBytes(data, offset);
		var fq_11or22_KHZ:Int = getTwoBytes(data, offset + 2);
		var zero:Int = getTwoBytes(data, offset + 6);
		if (three == 3 && (fq_11or22_KHZ == 11025 || fq_11or22_KHZ == 22050) && zero == 0) return DataLump.SOUNDFX;
		
		//PC Speaker sounds
		var short_a:Int = getTwoBytes(data, offset);
		var short_b:Int = getTwoBytes(data, offset + 2);
		if (32 + (short_b * 8) == _dir.size * 8 && short_a == 0) return DataLump.SOUNDPC;
		
		//graphic check
		var width:Int = getTwoBytes(data, offset);
		var highest = 0;
		var graphic:Bool = true;
		for (index in 0...width) {
			var c_offset:Int = getFourBytes(data, offset + 8 + (index * 4));
			if (c_offset > highest) {
				highest = c_offset;
				continue;
			} else {
				graphic = false;
				break;
			}
		}
		if (graphic) {
			var pheight:Int = getTwoBytes(data, offset + 2);
			var pcolumn = getFourBytes(data, offset + 8);
			var poffset = getOneByte(data, offset + pcolumn);
			var plength = getOneByte(data, offset + pcolumn + 1);
			var pterminate = getOneByte(data, offset + pcolumn + plength + 4);
			if (poffset <= pheight && plength <= pheight && (pterminate == 0xFF || pterminate == 0)) {
				return DataLump.GRAPHIC;
			}
		}
		
		//Engine.log('Lump type unknown: $_dir.name');
		return DataLump.UNKNOWN;
	}
	/**
	 * Get an 8 bit value from provided data and location
	 * @param	_data Data of current wad loaded
	 * @param	_offset Position of data needed
	 * @param	_signed Is value a signed value?
	 * @return Returns an integer from specified position
	 */
	public static inline function getOneByte(_data:Array<Int>, _offset:Int, _signed:Bool = false):Int {
		var val = _data[_offset];
		return(_signed == true && val > 127 ? val - 255 : val);
	}
	/**
	 * Get a 16 bit value (Short) from provided data and location
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
			if (_data[a] == 0) break;
			str += String.fromCharCode(_data[a]);
		}
		return str;
	}
}