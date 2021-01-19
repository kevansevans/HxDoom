package hxdoom.core.action;
import hxdoom.Engine;
import hxdoom.component.Actor;
import hxdoom.core.Defines;
import hxdoom.core.GameCore;
import hxdoom.core.action.Maputl;
import hxdoom.core.action.Move;
import hxdoom.core.action.Switch;
import hxdoom.enums.eng.MoveDirection;
import hxdoom.lumps.map.LineDef;

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
		distance = Maputl.getApproxDistance(target.xpos - _actor.xpos, target.ypos - _actor.ypos);
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
		
		if (_actor.info.reactionTime > 0) return  false;
		
		var target = _actor.target;
		var dist = (Maputl.getApproxDistance(target.xpos - _actor.xpos, target.ypos - _actor.ypos)) - 64;
		
		if (_actor.info.meleeState == null) dist -= 128;
		
		if (dist > 200) dist = 200;
		
		if (Engine.GAME.random.getRandom() < dist) return false;
		
		return true;
	}
	
	public static var diagSpeed = Defines.divFracHelper(47000);
	
	public static var xspeed:Array<Float> = [1, diagSpeed, 0, -diagSpeed, -1, -diagSpeed, 0, diagSpeed];
	public static var yspeed:Array<Float> = [0, diagSpeed, 1, diagSpeed, 0, -diagSpeed, -1, -diagSpeed];
	
	public static var move:Actor -> Bool = moveDefault;
	public static function moveDefault(_actor:Actor):Bool
	{
		var direction = _actor.movedir;
		var blkline:LineDef;
		
		if (direction == NO_DIRECTION) return false;
		
		var speed = _actor.info.speed;
		
		var tryx:Float = _actor.xpos + (speed * xspeed[direction]);
		var tryy:Float = _actor.ypos + (speed * yspeed[direction]);
		
		if (!Map.tryMove(_actor, tryx, tryy)) {
			
			if (_actor.flags.float && Defines.floatok) {
				if (_actor.zpos < Move.tmfloorz) {
					_actor.zpos += Defines.FLOATSPEED;
				} else {
					_actor.zpos -= Defines.FLOATSPEED;
				}
				_actor.flags.infloat = true;
				return  true;
			}
			
			blkline = Move.blockline;
			if (blkline == null || blkline.special == 0) {
				return false;
			}
			_actor.movedir = NO_DIRECTION;
			
			if (Switch.useSpecialLine(_actor, blkline)) {
				return true;
			}
			
			return false;
		}
		
		_actor.flags.infloat = false;
		if (!_actor.flags.float) {
			_actor.zpos = _actor.floorz;
		}
		
		return true;
	}
	
	public static var tryWalk:Actor -> Bool = tryWalkDefault;
	public static function tryWalkDefault(_actor:Actor):Bool
	{
		if (!move(_actor)) {
			return false;
		}
		_actor.movecount = Engine.GAME.random.getDiceRoll(15);
		return true;
	}
}