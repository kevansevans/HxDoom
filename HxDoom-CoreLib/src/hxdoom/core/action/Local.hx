package hxdoom.core.action;
/**
 * ...
 * @author Kaelan
 */
class Local //p_local.h
{
	public static var FRACBITS:Int = 16;
	public static var FRACUNIT:Fixed = 1 << FRACBITS;

	public static var FLOATSPEED = (FRACUNIT * 4);
	
	public static var MAXHEALTH = 100;
	public static var VIEWHEIGHT = (41 * FRACUNIT);
	
	public static var MELEERANGE:Fixed = 64 * FRACUNIT;
	
	public static var tmfloorz:Fixed;
	
}