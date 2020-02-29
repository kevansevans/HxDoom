package hxdoom.lumps.map;

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
	public var sector:Sector;
	public function new(_sectors:Array<Sector>, _xoff:Int, _yoff:Int, _upper:String, _lower:String, _middle:String, _sectorID:Int) 
	{
		xoffset = _xoff;
		yoffset = _yoff;
		upper_texture = _upper;
		lower_texture = _lower; 
		middle_texture = _middle;
		sector = _sectors[_sectorID];
	}
	
}