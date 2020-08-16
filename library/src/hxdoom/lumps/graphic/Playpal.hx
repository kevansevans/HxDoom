package hxdoom.lumps.graphic;

import hxdoom.enums.eng.ColorChannel;
import hxdoom.enums.eng.ColorMode;
import hxdoom.lumps.LumpBase;

/*
 * The idea is to keep the doom side of things separate from the API side of things
 * This in theory should make it easier to fork and adapt for other rendering frameworks
 */


/**
 * ...
 * @author Kaelan
 */
class Playpal extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> Playpal = Playpal.new;
	
	public var palettes:Array<Array<Int>>;
	public function new(_args:Array<Any>) 
	{
		super();
		
		palettes = new Array();
	}
	public function addSwatch(_index:Int, _color:Int) {
		if (palettes[_index] == null) palettes[_index] = new Array();
		palettes[_index].push(_color);
	}
	public function getColorChannelFloat(_index:Int, _channel:ColorChannel, _pal:Int = 0):Float {
		return getColorChannelInt(_index, _channel, _pal) / 255;
	}
	public function getColorChannelInt(_index:Int, _channel:ColorChannel, _pal:Int = 0):Int {
		
		if (_index == -1) return 0;
		
		var col:Int = palettes[_pal][_index];
		var val:Float = 0;
		switch (_channel) {
			case ColorChannel.RED:
				col = col >> 16;
			case ColorChannel.GREEN:
				col = (col >> 8) & 0xFF;
			case ColorChannel.BLUE:
				col = col & 0xFF;
			case ColorChannel.ALPHA:
				col = 0xFF;
		}
		return col;
	}
	public function getColorHex(_index:Int, _mode:ColorMode, _pal:Int = 0):Int {
		switch (_mode) {
			case RGB :
				if (_index == -1) return 0x000000;
				else return palettes[_pal][_index];
			case ARGB :
				if (_index == -1) return 0x00000000;
				else return 0xFF << 24 | palettes[_pal][_index];
			case RGBA :
				if (_index == -1) return 0x00000000;
				else return (palettes[_pal][_index] << 8) | 0xFF;
		}
	}
	public function toString():String {
		return ("Num Palettes Loaded: " + palettes.length);
	}
}