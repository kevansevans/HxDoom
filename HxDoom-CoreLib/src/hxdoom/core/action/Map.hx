package hxdoom.core.action;

import hxdoom.component.Actor;
import hxdoom.utils.math.Fixed;

import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 */
class Map 
{

	public static var TryMove:(Actor, Fixed, Fixed) -> Bool = P_TryMove;
	public static function P_TryMove(_actor:Actor, _x:Fixed, _y:Fixed):Bool
	{
		Engine.log(["Not finished here"]);
		
		
		var oldx:Fixed;
		
		return false;
		
	}
}