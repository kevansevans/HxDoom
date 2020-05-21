package hxdoom.lumps.graphic;

import haxe.ds.Vector;
import hxdoom.core.Reader;

/**
 * ...
 * @author Kaelan
 */
class Patch 
{
	public var width:Int;
	public var height:Int;
	public var offset_x:Int;
	public var offset_y:Int;
	public var columns:Vector<Vector<Int>>;
	public var data:Vector<Int>;
	public function new(_width:Int, _height:Int, _offsetX:Int, _offsetY:Int) 
	{
		width = _width;
		height = _height;
		offset_x = _offsetX;
		offset_y = _offsetY;
		columns = new Vector(width);
		data = new Vector(width * height);
	}
	
	public function toString():String {
		return ([
			'Width: {$width}, ',
			'Height: {$height}, ',
			'Offset: {X: $offset_x, Y: $offset_y}, ',
			'User must construct <data> into bitmap to test if data is being loaded correctly'
		]).join("");
	}
}