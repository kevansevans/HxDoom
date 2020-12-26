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
	
	public static function divFracHelper(_value:Int, ?_pos:PosInfos):Float {
		trace("Repalce me!", _value, _value / FRACDIVIDE, _pos);
		return (_value / FRACDIVIDE);
	}
}