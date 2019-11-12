package packages.actors;

/**
 * ...
 * @author Kaelan
 * 
 * Taking the GZDoom approach here and having each class type behave on inheritance rather than each possesing their own properties.
 */
class Thing 
{
	public var id:Int;
	public var xpos(default, set):Int;
	public var ypos(default, set):Int;
	public var angle(default, set):Int;
	
	public function new(_id:Int) 
	{
		id = _id;
	}
	
	function set_xpos(value:Int):Int 
	{
		return xpos = value;
	}
	function set_ypos(value:Int):Int 
	{
		return ypos = value;
	}
	function set_angle(value:Int):Int 
	{
		return angle = value;
	}
	
}