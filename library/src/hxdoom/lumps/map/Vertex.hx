package hxdoom.lumps.map;

import hxdoom.lumps.LumpBase;

/**
 * XY position of a linedef
 * ...
 * @author Kaelan
 */
class Vertex extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> Vertex = Vertex.new;
	
	public var xpos:Int;
	public var ypos:Int;
	public function new(_args:Array<Any>) 
	{
		super();
		
		xpos = _args[0];
		ypos = _args[1];
	}
	public function toString():String {
		return '{x: ' + xpos + ", y:" + ypos + '}'; 
	}
}