package packages.wad.maplumps;

/**
 * ...
 * @author Kaelan
 */
class SideDef 
{
	public var xoffset:Int;
	public var yoffset:Int;
	public var upper_texture:String;
	public var lower_texture:String;
	public var middle_texture:String;
	public var sector:Int;
	public function new(_xoff:Int, _yoff:Int, _upper:String, _lower:String, _middle:String, _sector:Int) 
	{
		xoffset = _xoff;
		yoffset = _yoff;
		upper_texture = _upper;
		lower_texture = _lower; 
		middle_texture = _middle;
		sector = _sector;
	}
	
}