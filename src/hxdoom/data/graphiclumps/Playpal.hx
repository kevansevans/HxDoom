package hxdoom.data.graphiclumps;

/*
 * The idea is to keep the doom side of things separate from the API side of things
 * This in theory should make it easier to fork and adapt for other rendering frameworks
 */

#if lime
import lime.graphics.Image;
#end

/**
 * ...
 * @author Kaelan
 */
class Playpal 
{
	public var palettes:Array<Array<Int>>;
	public function new() 
	{
		palettes = new Array();
	}
	public function addSwatch(_index:Int, _color:Int) {
		if (palettes[_index] == null) palettes[_index] = new Array();
		palettes[_index].push(_color);
	}
	public function getColor(_index:Int, _rgb:Int, _pal:Int = 0, _asFloat:Bool = false):Float {
		var col:Int = palettes[_pal][_index];
		var val:Float = 0;
		switch (_rgb) {
			case 0:
				col = col >> 16;
			case 1:
				col = (col >> 8) & 0xFF;
			case 2:
				col = col & 0xFF;
		}
		if (_asFloat) {
			return (col / 255);
		}
		return col;
	}
}