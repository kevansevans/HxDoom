package hxdoom.core.action;

import hxdoom.lumps.map.LineDef;
import hxdoom.component.Actor;
import hxdoom.component.Player;
import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 */
class Doors //p_doors.c
{

	public static var VerticalDoor:(LineDef, Actor) -> Void = EV_VerticalDoor;
	public static function EV_VerticalDoor(_line:LineDef, _actor:Actor):Void
	{
		var player:Player = _actor;
		
		Engine.log(["Not finished here"]);
	}
}