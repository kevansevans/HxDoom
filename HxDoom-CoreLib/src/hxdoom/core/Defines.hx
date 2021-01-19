package hxdoom.core;
import haxe.PosInfos;

/**
 * ...
 * @author Kaelan
 */
class Defines 
{
	public static inline var FRACDIVIDE:Int = 65536;
	
	public static inline var MAXMOVE:Int = 16;
	public static inline var MELEERANGE:Int = 64; //3D0 source actually has this defined as 70, but common Doom knowledge says it's 64
	public static inline var FLOATSPEED:Int = 8;
	
	public static inline var ANGLETOFINESHIFT:Int = 19;
	
	public static var trymove2:Bool;
	public static var floatok:Bool;
	
	public static inline function divFracHelper(_value:Int, ?_pos:PosInfos):Float {
		#if debug
		trace("Repalce me!", _value, _value / FRACDIVIDE, _pos);
		#end
		return (_value / FRACDIVIDE);
	}
}