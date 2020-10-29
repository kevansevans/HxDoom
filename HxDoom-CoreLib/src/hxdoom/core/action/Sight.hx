package hxdoom.core.action;

import hxdoom.component.Actor;

import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 */
class Sight //p_sight.c
{

	public static var CheckSight:(Actor, Actor) -> Bool = P_CheckSight;
	public static function P_CheckSight(_t1:Actor, _t2:Actor):Bool
	{
		Engine.log(["Not finished here"]);
		
		var s1:Int;
		var s2:Int;
		var pnum:Int;
		var bytenum:Int;
		var bitnum:Int;
		
		s1 = Engine.LEVELS.currentMap.sectors.indexOf(_t1.get_subsector().sector) - Engine.LEVELS.currentMap.sectors.indexOf(Extern.SECTORS);
		s2 = Engine.LEVELS.currentMap.sectors.indexOf(_t2.get_subsector().sector) - Engine.LEVELS.currentMap.sectors.indexOf(Extern.SECTORS);
		pnum = s1 * Engine.LEVELS.currentMap.sectors.length + s2;
		bytenum = pnum >> 3;
		bitnum = 1 << (pnum & 7);
		
		return false;
	}
	
}