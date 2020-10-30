package hxdoom.core.action;

import hxdoom.component.Actor;

import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 */
class Map 
{

	public static var TryMove:(Actor, Float, Float) -> Bool = P_TryMove;
	public static function P_TryMove(_actor:Actor, _x:Float, _y:Float):Bool
	{
		Engine.log(["Not finished here"]);
		
		var oldx:Float;
		
		return false;
		
	}
}