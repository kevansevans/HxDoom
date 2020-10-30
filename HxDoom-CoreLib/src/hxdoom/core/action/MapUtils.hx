package hxdoom.core.action;

import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Sector;

/**
 * ...
 * @author Kaelan
 */
class MapUtils //p_matutl.c
{

	public static var AproxDistance:(Float, Float) -> Float = P_AproxDistance;
	public static function P_AproxDistance(_dx:Float, _dy:Float):Float 
	{
		
		Engine.log(["Test me!"]);
		
		var dx = Math.abs(_dx);
		var dy = Math.abs(_dy);
		
		if (dx < dy) return (dx + dy - (Std.int(dx) >> 1));
		else return (dx + dy - (Std.int(dy) >> 1));
	}
}