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
	public var xpos:Int;
	public var ypos:Int;
	public var angle:Int;
	
	public function new(_id:Int) 
	{
		id = _id;
	}
	
}