package hxdoom.lumps;
import haxe.io.Bytes;

/**
 * ...
 * @author Kaelan
 */
class Directory 
{
	public var data:Array<Int>;
	public var dataOffset:Int;
	public var listIndex:Int;
	public var size:Int;
	public var name:String;
	public function new(_dataOffset:Int, _size:Int, _name:String) 
	{
		dataOffset = _dataOffset;
		size = _size;
		name = _name;
	}
	
}