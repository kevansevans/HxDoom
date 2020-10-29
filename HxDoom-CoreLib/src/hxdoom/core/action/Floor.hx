package hxdoom.core.action;

import hxdoom.lumps.map.LineDef;
import hxdoom.enums.eng.StairType;
import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 */
class Floor //p_floor.c
{

	public static var BuildStairs:(LineDef, StairType) -> Int = EV_BuildStairs;
	public static function EV_BuildStairs(_line:LineDef, _type:StairType):Int
	{
		Engine.log(["Not finished here"]);
		
		return 0;
	}
	
}