package hxdoom.core.action;

import h2d.Slider;
import hxdoom.component.Actor;

/**
 * ...
 * @author Kaelan
 * 
 * from https://github.com/Olde-Skuul/doom3do/blob/master/source/user.c
 */
class User 
{

	public static var PlayerMove:Actor -> Void = PlayerMoveDefault;
	public static function PlayerMoveDefault(_actor:Actor):Void
	{
		var momx:Float;
		var momy:Float;
		
		Slide.SlideMove(_actor);
	}
	
	
}