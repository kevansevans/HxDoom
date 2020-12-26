package hxdoom.core.action;
import hxdoom.Engine;
import hxdoom.component.Actor;
import hxdoom.core.Defines;
import hxdoom.utils.math.Map;

/**
 * ...
 * @author Kaelan
 * 
 * From https://github.com/Olde-Skuul/doom3do/blob/master/source/enemy.c
 * 
 * This is to contain the generic actions that Doom enemies have.
 * IE Spawn projectiles or face a direction.
 * 
 * All methods here can be overidden externally by setting the respective var
 * to a new function.
 * 
 */
class Enemy 
{

	/**
	 * Check if actor is within distance to perform a melee attack,
	 * assuming it has a melee attack defined
	 */
	public static var checkMeleeRange:Actor -> Bool = checkMissileRangeDefault;
	public static function checkMeleeRangeDefault(_actor:Actor):Bool
	{
		var target:Actor = _actor.target;
		
		if (target == null || !_actor.flags.seetarget) {
			return false;
		}
		
		var distance:Float;
		distance = Map.getApproxDistance(target.xpos - _actor.xpos, target.ypos - _actor.ypos);
		if (distance >= Defines.MELEERANGE) return false;
		
		return true;
	}
	/**
	 * Check if an actor is within range to spawn a missile attack, assuming
	 * said actor can fire a missile.
	 */
	public static var checkMissileRange:Actor -> Bool = checkMissileRangeDefault;
	public static function checkMissileRangeDefault(_actor:Actor):Bool
	{
		if (!_actor.flags.seetarget) {
			return false;
		}
		
		if (_actor.flags.justhit) {
			_actor.flags.justhit = false;
			return  true;
		}
		
		if (_actor.reactiontime > 0) return  false;
		
		var target = _actor.target;
		var dist = (Map.getApproxDistance(target.xpos - _actor.xpos, target.ypos - _actor.ypos)) - 64;
		
		/*if actor does not have melee state, subtract distance by 128*/
		
		/*If actor is a lost skull, divide by two. Will need to be delegated into Gamelib*/
		
		if (dist > 200) dist = 200;
		
	}
	
}