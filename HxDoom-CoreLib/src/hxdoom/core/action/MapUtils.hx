package hxdoom.core.action;

import hxdoom.utils.math.Fixed;

/**
 * ...
 * @author Kaelan
 */
class MapUtils //p_matutl.c
{

	public static var AproxDistance:(Fixed, Fixed) -> Fixed = P_AproxDistance;
	public static function P_AproxDistance(_dx:Fixed, _dy:Fixed):Fixed 
	{
		
		Engine.log(["Test me!"]);
		
		var dx = Math.abs(_dx);
		var dy = Math.abs(_dy);
		
		if (dx < dy) return (dx + dy - (Std.int(dx) >> 1));
		else return (dx + dy - (Std.int(dy) >> 1));
	}
}