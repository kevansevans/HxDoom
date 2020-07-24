package hxdoom.core;

import hxdoom.actors.Actor;
import hxdoom.utils.geom.Angle;

/**
 * ...
 * @author Kaelan
 */
class ActorCore 
{
	public static var ActorList:Array<Void -> Void>
	public static var ActiveList:Array<Actor>;
	
	public static function Summon(_actorID:Int, _x:Float = 0, _y:Float = 0, _angle:Angle = 0) {
		if (ActorList[_actorID] == null) {
			ActiveList.push(Actor.CONSTRUCTOR([]);
		}
	}
	
	public function new() 
	{
		
	}
	
}