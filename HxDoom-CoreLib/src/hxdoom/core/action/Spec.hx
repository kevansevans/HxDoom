package hxdoom.core.action;

import hxdoom.lumps.map.LineDef;
import hxdoom.component.Actor;

import hxdoom.Engine;



/**
 * ...
 * @author Kaelan
 */
class Spec 
{

	public static var CrossSpecialLine:(LineDef, Int, Actor) -> Void;
	public static function P_CrossSpecialLine(_line:LineDef, _side:Int, _actor:Actor):Void
	{
		Engine.log(["Not finished here"]);
	}
	
}