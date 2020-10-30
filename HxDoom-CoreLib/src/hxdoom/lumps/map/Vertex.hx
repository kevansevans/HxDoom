package hxdoom.lumps.map;

import haxe.io.Bytes;

import hxdoom.lumps.LumpBase;

/**
 * XY position of a linedef
 * ...
 * @author Kaelan
 */
class Vertex extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> Vertex = Vertex.new;
	
	public static inline var BYTE_SIZE:Int = 4;
	
	public var xpos:Float;
	public var ypos:Float;
	public function new(_args:Array<Any>) 
	{
		super();
		
		xpos = _args[0];
		ypos = _args[1];
	}
	override public function toDataBytes():Bytes 
	{
		var bytes:Bytes = Bytes.alloc(BYTE_SIZE);
		bytes.setUInt16(0, xpos);
		bytes.setUInt16(2, ypos);
		return bytes;
	}
	public function toString():String {
		return '{x: ' + xpos + ", y:" + ypos + '}'; 
	}
	
	public static function distance(_b:Vertex, _a:Vertex):Float {
		return Math.sqrt(Math.pow(_b.xpos - _a.xpos, 2) + Math.pow( _b.ypos - _a.ypos, 2));
	}
}