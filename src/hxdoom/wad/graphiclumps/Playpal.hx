package hxdoom.wad.graphiclumps;

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
	#if lime
	public function getImageOfPalette(_palette:Int):Image {
		var pal:Image = new Image();
		pal.width = pal.height = 16;
		var index:Int = 0;
		for (y in 0...16) {
			for (x in 0...16) {
				pal.setPixel(x, y, palettes[_palette][index]);
				++index;
			}
		}
		return pal;
	}
	#end
}