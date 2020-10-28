package hxdoom.lumps;
import haxe.io.Bytes;

/**
 * ...
 * @author Kaelan
 */
class Directory extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> Directory = Directory.new;
	
	public static inline var BYTE_SIZE:Int = 16;
	
	public var dataOffset:Int;
	public var size:Int;
	public var name:String;
	public var wad:String;
	public var index:Int;
	public function new(_args:Array<Any>) 
	{
		super();
		
		dataOffset = 	_args[0];
		size = 			_args[1];
		name = 			_args[2];
		wad = 			_args[3];
		index = 		_args[4];
	}
	
	public function toString():String {
		return([
		
		"Wad: {" + wad + "}",
		"Name: {" + name + "}",
		"Size: {" + size + "}",
		"Offset: {" + dataOffset + "}"
		
		].join(""));
	}
	
}