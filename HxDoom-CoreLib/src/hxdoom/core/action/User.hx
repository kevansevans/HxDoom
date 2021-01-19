package hxdoom.core.action;

import h2d.Slider;
import hxdoom.Engine;
import hxdoom.component.Actor;
import hxdoom.core.Defines;

/**
 * ...
 * @author Kaelan
 * 
 * from https://github.com/Olde-Skuul/doom3do/blob/master/source/user.c
 */
class User 
{

	public static var playerMove:Actor -> Void = PlayerMoveDefault;
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
				_actor.momx = _actor.momy = 0;
			}
			
		} while (false)
		
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
			if (_actor.flags.corpse) {
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
			if (_actor.momz < 0) {
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
	
	public static function buildMove:Actor -> 
	
}