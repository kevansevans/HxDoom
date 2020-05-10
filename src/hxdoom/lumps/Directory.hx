package hxdoom.lumps;
import haxe.io.Bytes;

/**
 * ...
 * @author Kaelan
 */
class Directory 
{
	public var dataOffset:Int;
	public var listIndex:Int;
	public var size:Int;
	public var name:String;
	public var wad:String;
	public function new(_dataOffset:Int, _size:Int, _name:String, _wad:String) 
	{
		dataOffset = _dataOffset;
		size = _size;
		name = _name;
		wad = _wad;
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