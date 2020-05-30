package hxdoom.lumps;
import haxe.io.Bytes;

/**
 * ...
 * @author Kaelan
 */
class Directory 
{
	public var dataOffset:Int;
	public var size:Int;
	public var name:String;
	public var wad:String;
	public var index:Int;
	public function new(_dataOffset:Int, _size:Int, _name:String, _wad:String, _index:Int) 
	{
		dataOffset = _dataOffset;
		size = _size;
		name = _name;
		wad = _wad;
		index = _index;
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