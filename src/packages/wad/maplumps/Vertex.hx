package packages.wad.maplumps;

/**
 * XY position of a linedef
 * ...
 * @author Kaelan
 */
class Vertex 
{
	public var xpos:Int;
	public var ypos:Int;
	public function new(_x:Int, _y:Int) 
	{
		xpos = _x;
		ypos = _y;
	}
	
}

/*typedef Vertex = {
	var x:Int;
	var y:Int;
}*/