package hxdoom.core;

import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import hxdoom.enums.eng.DataLump;
import hxdoom.enums.eng.KeyLump;
import hxdoom.lumps.Directory;
import hxdoom.lumps.audio.SoundEffect;
import hxdoom.lumps.graphic.PatchNames;
import hxdoom.lumps.graphic.Patch;
import hxdoom.lumps.graphic.TextureInfo;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.LineDefHexen;
import hxdoom.lumps.map.Node;
import hxdoom.lumps.map.Sector;
import hxdoom.lumps.map.Segment;
import hxdoom.lumps.map.SideDef;
import hxdoom.lumps.map.SubSector;
import hxdoom.lumps.map.Thing;
import hxdoom.lumps.map.Vertex;
import hxdoom.typedefs.graphics.PatchLayout;

/**
 * ...
 * @author Kaelan
 */
class Reader 
{
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
	public static var readDirectory:(Array<Int>, Int, String, ?Int) -> Directory = readDirectoryDefault;
	public static function readDirectoryDefault(_data:Array<Int>, _offset:Int, _wadname:String = "", _index:Int = -1):Directory {
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
	public static var readThing:(Array<Int>, Int) -> Thing = readThingDefault;
	public static function readThingDefault(_data:Array<Int>, _offset:Int):Thing {
		return Thing.CONSTRUCTOR([
			getTwoBytes(_data, _offset, true),
			getTwoBytes(_data, _offset + 2, true),
			getTwoBytes(_data, _offset + 4, true),
			getTwoBytes(_data, _offset + 6, true),
			getTwoBytes(_data, _offset + 8, true)
		]);
	}
	/**
	 * Reads from provided data and returns a vanilla compatible Linedef
	 * @param	_data
	 * @param	_offset
	 * @return
	 */
	public static var readLinedef:(Array<Int>, Int) -> LineDef = readLinedefDefault;
	public static function readLinedefDefault(_data:Array<Int>, _offset:Int):LineDef {
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
	 * Reads from provided data and returns a Hexen compatible Linedef
	 * @param	_data
	 * @param	_offset
	 * @return 
	 */
	public static var readHexenLinedef:(Array<Int>, Int) -> LineDefHexen = function(_data:Array<Int>, _offset:Int):LineDefHexen {
		return LineDefHexen.CONSTRUCTOR([
			getTwoBytes(_data, _offset),
			getTwoBytes(_data, _offset + 2),
			getTwoBytes(_data, _offset + 4),
			getOneByte(_data, _offset + 6),
			getOneByte(_data, _offset + 7),
			getOneByte(_data, _offset + 8),
			getOneByte(_data, _offset + 9),
			getOneByte(_data, _offset + 10),
			getOneByte(_data, _offset + 11),
			getTwoBytes(_data, _offset + 12),
			getTwoBytes(_data, _offset + 14),
		]);
	}
	/**
	 * Reads from provided data and returns a new Vertex
	 * @param	_data
	 * @param	_offset
	 * @return
	 */
	public static var readVertex:(Array<Int>, Int) -> Vertex = readVertexDefault;
	public static function readVertexDefault(_data:Array<Int>, _offset:Int):Vertex {
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
	public static var readSegment:(Array<Int>, Int) -> Segment = readSegmentDefault;
	public static function readSegmentDefault(_data:Array<Int>, _offset:Int):Segment {
		return Segment.CONSTRUCTOR([
			getTwoBytes(_data, _offset, true),
			getTwoBytes(_data, _offset + 2, true),
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
	public static var readSubSector:(Array<Int>, Int) -> SubSector = readSubSectorDefault;
	public static function readSubSectorDefault(_data:Array<Int>, _offset:Int):SubSector {
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
	public static var readNode:(Array<Int>, Int) -> Node = readNodeDefault;
	public static function readNodeDefault(_data:Array<Int>, _offset:Int):Node {
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
	public static var readSideDef:(Array<Int>, Int) -> SideDef = readSideDefDefault;
	public static function readSideDefDefault(_data:Array<Int>, _offset:Int):SideDef {
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
	public static var readSector:(Array<Int>, Int) -> Sector = readSectorDefault;
	public static function readSectorDefault(_data:Array<Int>, _offset:Int):Sector {
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
	 * Read lump as PName
	 * @param	_data
	 * @param	_offset
	 * @param	_size
	 * @return
	 */
	public static var readPatchNames:(Array<Int>, Int) -> PatchNames = readPatchNamesDefault;
	public static function readPatchNamesDefault(_data:Array<Int>, _offset:Int):PatchNames {
		var pname = PatchNames.CONSTRUCTOR([]);
		var numPatches = getFourBytes(_data, _offset);
		for (a in 0...numPatches) {
			pname.addPatchName(getStringFromRange(_data, (_offset + 4) + (a * 8), (_offset + 4) + ((a + 1) * 8)));
		}
		return pname;
	}
	public static var readTextureInfo:(Array<Int>, Int) -> TextureInfo = readTextureInfoDefault;
	public static function readTextureInfoDefault(_data:Array<Int>, _offset:Int):TextureInfo {
		
		var numTextures = getFourBytes(_data, _offset);
		var offsets:Array<Int> = new Array();
		for (a in 0...numTextures) {
			offsets.push(getFourBytes(_data, (_offset + 4) + (a * 4)));
		}
		
		var textureSet = TextureInfo.CONSTRUCTOR([
			numTextures,
			offsets
		]);
		
		for (texOffset in textureSet.offsets) {
			var textureData:TextureData = {
				textureName : getStringFromRange(_data, _offset + texOffset, _offset + texOffset + 8).toUpperCase(),
				width : getTwoBytes(_data, _offset + texOffset + 0x0C),
				height : getTwoBytes(_data, _offset + texOffset + 0x0E),
				numPatches : getTwoBytes(_data, _offset + texOffset + 0x14),
				layout : getPatchLayoutList(_data, _offset + texOffset + 0x16)
			}
			textureSet.addTextureData(textureData);
		}
		return textureSet;
	}
	public static var getPatchLayoutList:(Array<Int>, Int) -> Array<PatchLayout> = getPatchLayoutListDefault;
	public static function getPatchLayoutListDefault(_data:Array<Int>, _offset:Int):Array<PatchLayout> {
		var patchlist:Array<PatchLayout> = new Array();
		for (p in 0...getTwoBytes(_data, _offset - 2)) {
			var layout:PatchLayout = {
				offset_x : getTwoBytes(_data, _offset + (p * 10), true),
				offset_y : getTwoBytes(_data, _offset + (p * 10) + 2, true),
				patchIndex : getTwoBytes(_data, _offset + (p * 10) + 4)
			}
			patchlist.push(layout);
		}
		return patchlist;
	}
	/**
	 * Read data and return a patch from given location
	 * @param	_data Specified wad data array
	 * @param	_offset Location of patch
	 * @return New patch with correct data values
	 *///With thanks to Phantombeta for getting this to work
	public static var readPatch:(Array<Int>, Int) -> Patch = readPatchDefault;
	public static function readPatchDefault(_data:Array<Int>, _offset:Int):Patch {
			
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
	public static var readSound:(Array<Int>, Int) -> SoundEffect = function(_data:Array<Int>, _offset:Int):SoundEffect
	{
		var samplerate = getTwoBytes(_data, _offset + 2);
		var numsamples = getTwoBytes(_data, _offset + 4);
		
		var sampleBytes:BytesBuffer = new BytesBuffer();
		
		for (samplepos in 0...numsamples) {
			sampleBytes.addByte(getOneByte(_data, _offset + 8 + samplepos));
		}
		
		return SoundEffect.CONSTRUCTOR([
			samplerate,
			numsamples,
			sampleBytes.getBytes()
		]);
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
	public static var getOneByte:(Array<Int>, Int, ?Bool) -> Int = getOneByteDefault;
	public static function getOneByteDefault(_data:Array<Int>, _offset:Int, _signed:Bool = false):Int {
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
	public static var getTwoBytes:(Array<Int>, Int, ?Bool) -> Int = getTwoBytesDefault; //16 bits
	public static function getTwoBytesDefault(_data:Array<Int>, _offset:Int, _signed:Bool = false):Int
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
	public static var getFourBytes:(Array<Int>, Int) -> Int = getFourBytesDefault;
	public static function getFourBytesDefault(_data:Array<Int>, _offset:Int):Int {
		return((_data[_offset + 3] << 24) | (_data[_offset + 2] << 16) | (_data[_offset + 1] << 8) | _data[_offset]);
	}
	/**
	 * Get and construct a string value from specified range 
	 * @param	_data Data of current wad loaded
	 * @param	_start Start position of string
	 * @param	_end End position of string
	 * @return	Returns a UTF8 compatible string. Automatically removes null and empty characters.
	 */
	public static var getStringFromRange:(Array<Int>, Int, Int) -> String = getStringFromRangeDefault;
	public static function getStringFromRangeDefault(_data:Array<Int>, _start:Int, _end:Int):String {
		var str:String = "";
		for (a in _start..._end) {
			if (_data[a] == 0 || Math.isNaN(_data[a])) break;
			str += String.fromCharCode(_data[a]);
		}
		return str;
	}
}