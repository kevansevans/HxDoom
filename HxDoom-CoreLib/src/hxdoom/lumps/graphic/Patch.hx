package hxdoom.lumps.graphic;

import haxe.ds.Vector;
import hxdoom.core.Reader;
import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class Patch extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> Patch = Patch.new;
	
	public var width:Int;
	public var height:Int;
	public var offset_x:Int;
	public var offset_y:Int;
	public var pixels:Vector<Vector<Int>>;
	public function new(_args:Array<Any>) 
	{
		super();
		
		if (override_new) return;
		
		width = 	_args[0];
		height = 	_args[1];
		offset_x = 	_args[2];
		offset_y = 	_args[3];
		pixels = new Vector(width);
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