package packages.wad.maplumps;

/**
 * ...
 * @author Kaelan
 */
class Directory 
{
	public var offset:Int;
	public var size:Int;
	public var name:String;
	public function new(_offset:Int, _size:Int, _name:String) 
	{
		offset = _offset;
		size = _size;
		name = _name;
	}
	
}