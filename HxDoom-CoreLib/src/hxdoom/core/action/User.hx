package hxdoom.core.action;

import hxdoom.Engine;
import hxdoom.component.Actor;
import hxdoom.core.Defines;
import hxdoom.core.GameCore;
import hxdoom.enums.data.Defaults;
import hxdoom.utils.geom.Angle;

/**
 * ...
 * @author Kaelan
 * 
 * from https://github.com/Olde-Skuul/doom3do/blob/master/source/user.c
 */
class User 
{
	public static inline var SLOWTURNTICS:Int = 10;
	
	public static var angleturn:Array<Int> = 		[600, 600, 1000, 1000, 1200, 1400, 1600, 1800, 1800, 2000];
	public static var fastangleturn:Array<Float> = 	[400, 400, 450, 500, 500, 600, 600, 650, 650, 700];
	public static var forwardMove:Array<Float> = [Defines.divFracHelper(0x38000 / 4), Defines.divFracHelper(0x60000 / 4)];
	public static var sideMove:Array<Float> = [Defines.divFracHelper(0x38000 / 4), Defines.divFracHelper(0x58000 / 4)];
	
	public static var playerMove:Actor -> Void = playerMoveDefault;
	public static function playerMoveDefault(_actor:Actor):Void
	{
		var momx:Float;
		var momy:Float;
		
		//Needs to be replaced with elapsed time
		momx = 1 * (_actor.momx / 4);
		momy = 1 * (_actor.momy / 4);
		
		Slide.SlideMove(_actor);
		
		do  {
			if (Slide.slidex != _actor.xpos || Slide.slidey != _actor.ypos) {
				
				if (Map.tryMove(_actor, Slide.slidex, Slide.slidey)) {
					break;
				}
				
			}
			
			if (momx > Defines.MAXMOVE) {
				momx = Defines.MAXMOVE;
			}
			if (momx < -Defines.MAXMOVE) {
				momx = -Defines.MAXMOVE;
			}
			if (momy > Defines.MAXMOVE) {
				momy = Defines.MAXMOVE;
			}
			if (momy < -Defines.MAXMOVE) {
				momy = -Defines.MAXMOVE;
			}
			
			if (Map.tryMove(_actor, _actor.xpos, _actor.ypos + momy)) {
				_actor.momx = 0;
				_actor.momy = momy;
			} else if (Map.tryMove(_actor, _actor.momx + momx, _actor.momy)) {
				_actor.momx = momx;
				_actor.momy = 0;
			} else {
				//_actor.momx = _actor.momy = 0;
			}
			
		} while (false);
		
		//cross special line
		Engine.log(['Unfinished function here']);
	}
	
	public static inline var STOPSPEED:Int = 0x1000;
	public static inline var FRICTION:Int = 0xD240;
	
	public static var playerXYMovement:Actor -> Void = playerXYMovementDefault;
	public static function playerXYMovementDefault(_actor:Actor):Void
	{
		playerMove(_actor);
		
		if (_actor.zpos <= _actor.floorz) {
			
			_actor.zpos = _actor.floorz;
			
			if (_actor.flags.corpse == true) {
				if (_actor.floorz != _actor.subsector.sector.floorHeight) return;
			}
			
			if (_actor.momx > -Defines.divFracHelper(STOPSPEED) && _actor.momx < Defines.divFracHelper(STOPSPEED) &&
				_actor.momy > -Defines.divFracHelper(STOPSPEED) && _actor.momy < Defines.divFracHelper(STOPSPEED)) {
					_actor.momx = _actor.momy = 0;
			} else {
				_actor.momx = _actor.momx * Defines.divFracHelper(FRICTION);
				_actor.momy = _actor.momy * Defines.divFracHelper(FRICTION);
			}
		}
	}
	
	public static var playerZMovement:Actor -> Void = playerZMovementDefault;
	public static function playerZMovementDefault(_actor:Actor):Void
	{
		if (_actor.zpos < _actor.floorz) {
			_actor.zpos_view -= _actor.floorz - _actor.zpos;
			_actor.deltaviewheight = (Defines.VIEWHEIGHT - _actor.zpos_view) / 4;
		}
		_actor.zpos += _actor.momz;
		
		if (_actor.zpos <= _actor.floorz) {
			if (_actor.momz != 0) {
				if (_actor.momz < -Defines.GRAVITY * 4) {
					_actor.deltaviewheight = _actor.momz / 8;
					//grunt sound!
				}
				_actor.momz = 0;
			}
			_actor.zpos = _actor.floorz;
		} else {
			if (_actor.momz == 0) {
				_actor.momz = -Defines.GRAVITY * 2;
			} else {
				_actor.momz -= Defines.GRAVITY;
			}
		}
		if (_actor.zpos + _actor.height > _actor.ceilingz) {
			if (_actor.momz > 0) {
				_actor.momz = 0;
			}
			_actor.zpos = _actor.ceilingz - _actor.height;
		}
	}
	
	public static var playerMobjThink:Actor -> Void = playerMobjThinkDefault;
	public static function playerMobjThinkDefault(_actor:Actor):Void
	{
		
		Map.checkPosition(_actor, _actor.xpos, _actor.ypos);
		//REMOVE ME LATER!
		
		if (_actor.momx != 0 || _actor.momy != 0) {
			playerXYMovement(_actor);
		}
		
		if (_actor.zpos != _actor.floorz || _actor.momz != 0) {
			playerZMovement(_actor);
		}
		
		//cycle states
		Engine.log(['Unsinished function here']);
		
	}
	
	public static var playerThink:Actor -> Void = playerThinkDefault;
	public static function playerThinkDefault(_actor:Actor):Void
	{
		playerMobjThink(_actor);
		buildMove(_actor);
		
		//if player just attacked
		
		//if player is dead
		
		var i = _actor.info.reactionTime;
		if (i == 0) {
			moveThePlayer(_actor);
		} else {
			if (Engine.GAME.elapsedTime < i) {
				i -= Engine.GAME.elapsedTime;
			} else {
				i = 0;
			}
			_actor.info.reactionTime = i;
		}
		
		//use button here
		
		//weapon attacks
		
		//power up timers
	}
	
	public static var moveThePlayer:Actor -> Void = moveThePlayerDefault;
	public static function moveThePlayerDefault(_actor:Actor):Void
	{
		_actor.yaw += Defines.divFracHelper(_actor.angleturn);
		
		var onground = (_actor.zpos <= _actor.floorz);
		
		if (onground) {
			playerThrust(_actor, _actor.yaw, _actor.forwardmove);
			playerThrust(_actor, _actor.yaw - 90, _actor.sidemove);
		}
		
		if (_actor.forwardmove != 0 && _actor.sidemove != 0) {
			
		}
	}
	
	public static var buildMove:Actor -> Void = buildMoveDefault;
	public static function buildMoveDefault(_actor:Actor):Void
	{
		var motion:Float = 0;
		var turnindex:Int = 0;
		var speedindex:Int = 0;
		
		var running:Bool = CVarCore.getCvar(Defaults.PLAYER_HOLDING_RUN);
		var turnLeft:Bool = CVarCore.getCvar(Defaults.PLAYER_TURNING_LEFT);
		var turnRight:Bool = CVarCore.getCvar(Defaults.PLAYER_TURNING_RIGHT);
		var strafeLeft:Bool = CVarCore.getCvar(Defaults.PLAYER_STRAFING_LEFT);
		var strafeRight:Bool = CVarCore.getCvar(Defaults.PLAYER_STRAFING_RIGHT);
		var moveForward:Bool = CVarCore.getCvar(Defaults.PLAYER_MOVING_FORWARD);
		var moveBackward:Bool = CVarCore.getCvar(Defaults.PLAYER_MOVING_BACKWARD);
		
		turnindex = _actor.turnheld + Engine.GAME.elapsedTime;
		speedindex = running ? 1 : 0;
		
		if (!turnLeft || !turnRight) {
			turnindex = 0;
		}
		if (turnindex >= SLOWTURNTICS) {
			turnindex - SLOWTURNTICS - 1;
		}
		_actor.turnheld = turnindex;
		
		motion = 0;
		if (strafeLeft || strafeRight) {
			motion = sideMove[speedindex];
			if (strafeLeft) {
				motion = -motion;
			}
		}
		_actor.sidemove = motion;
		
		motion = 0;
		if (turnLeft || turnRight) {
			
			if (running) {
				motion = (fastangleturn[turnindex] / 65536) * 360;
			} else {
				motion = (angleturn[turnindex] / 65536) * 360;
				if (Engine.GAME.elapsedTime < 4) {
					motion /= 2;
					if (Engine.GAME.elapsedTime < 2) {
						motion /= 2;
					}
				}
			}
			if (turnRight) {
				motion = -motion;
			}
		}
		_actor.angleturn = motion;
		
		motion = 0;
		if (moveForward || moveBackward) {
			motion = forwardMove[speedindex];
			if (moveBackward) {
				motion = -motion;
			}
		}
		_actor.forwardmove = motion;
	}
	
	public static var playerThrust:(Actor, Angle, Float) -> Void = playerThrustDefault;
	public static function playerThrustDefault(_actor:Actor, _angle:Angle, _move:Float):Void
	{
		
		_actor.yaw += _actor.angleturn;
		
		if (_move != 0) {
			_actor.momx += (_move * Math.cos(_angle.toRadians()));
			_actor.momy += (_move * Math.sin(_angle.toRadians()));
		}
		
		//NOT SUPPOSED TO BE HERE
		_actor.xpos += _actor.momx;
		_actor.ypos += _actor.momy;
		
	}
	
}