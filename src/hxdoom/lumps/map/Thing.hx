package hxdoom.lumps.map;

/**
 * ...
 * @author Kaelan
 */
class Thing 
{
	public var xpos:Int;
	public var ypos:Int;
	public var angle:Int;
	public var type:Int;
	public var flags:Int;
	public function new(_xpos:Int, _ypos:Int, _angle:Int, _type:Int, _flags:Int) 
	{
		xpos = _xpos;
		ypos = _ypos;
		angle = _angle;
		type = _type;
		flags = _flags;
	}
	
}
/*
typedef Thing = {
	var xpos:Int;
	var ypos:Int;
	var angle:Int;
	var type:Int;
	var flags:Int;
}
*/