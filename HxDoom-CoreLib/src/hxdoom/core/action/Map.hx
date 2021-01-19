package hxdoom.core.action;

import hxdoom.Engine;
import hxdoom.component.Actor;
import hxdoom.core.Defines;
import hxdoom.core.action.Move;
import hxdoom.enums.eng.MoveDirection;

/**
 * ...
 * @author Kaelan
 */
class Map 
{
	public static var tmthing:Actor;
	public static var checkposonly:Bool;
	
	public static var diagSpeed = Defines.divFracHelper(47000);
	public static var xspeed:Array<Float> = [1, diagSpeed, 0, -diagSpeed, -1, -diagSpeed, 0, diagSpeed];
	public static var yspeed:Array<Float> = [0, diagSpeed, 1, diagSpeed, 0, -diagSpeed, -1, -diagSpeed];

	public static var tryMove:(Actor, Float, Float) -> Bool = tryMoveDefault;
	public static function tryMoveDefault(_actor:Actor, _x:Float, _y:Float):Bool
	{
		
		Move.tryMove2();
		
		var latchedmovething:Actor = Move.movething;
		var damage:Float;
		
		if (latchedmovething != null) 
		{
			if (_actor.flags.missile) {
				damage = Engine.GAME.random.getDiceRoll(7) * _actor.info.damage;
				//damage function if hit by missile;
				Engine.log(["Not finished here"]);
			//else if thing is a lost skull, delegate towards GameLib
			} else {
				//attempt to pick something up...?
				Engine.log(["Not finished here"]);
			}
		}
		
		return Defines.trymove2;
	}
	
}