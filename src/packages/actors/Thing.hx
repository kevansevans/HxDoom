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
	public var type:TypeID;
	public var group:TypeGroup;
	
	public var isPlayer(get, never):Bool;
	
	public function new(_id:Int) 
	{
		id = _id;
		group = TypeGroup.UNDEFINED;
	}
	
	//Setters
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
	
	//getters
	function get_isPlayer():Bool 
	{
		switch (type) {
			case TypeID.PLAYERONE | TypeID.PLAYERTWO | TypeID.PLAYERTHREE | TypeID.PLAYERFOUR :
				return true;
			default :
				return false;
		}
	}
}