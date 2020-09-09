package hxdoom.lumps.map;

import haxe.io.Bytes;
import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class Thing extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> Thing = Thing.new;
	
	public static inline var BYTE_SIZE:Int = 10;
	
	public var xpos:Int;
	public var ypos:Int;
	public var angle:Int;
	public var type:Int;
	public var flags:Int;
	public function new(_args:Array<Any>) 
	{
		super();
		
		xpos = 	_args[0];
		ypos = 	_args[1];
		angle = _args[2];
		type = 	_args[3];
		flags = _args[4];
	}
	
	public function toString():String {
		return([	'Position {x :' + xpos + ', y: ' + ypos + '}, ',
					'Direction {Angle: ' + angle + '}, ',
					'Type: {ThingID: ' + type + '}, ',
					'Flags: {' + flags + '}'
		
		].join(""));
	}
	
	override public function toDataBytes():Bytes 
	{
		var bytes = Bytes.alloc(BYTE_SIZE);
		bytes.setUInt16(0, xpos);
		bytes.setUInt16(2, ypos);
		bytes.setUInt16(4, angle);
		bytes.setUInt16(6, type);
		bytes.setUInt16(8, flags);
		return bytes;
	}
}