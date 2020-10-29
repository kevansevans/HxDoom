package hxdoom.core;

import haxe.ds.Vector;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Sector;
/**
 * ...
 * @author Kaelan
 */

//Any and all externs and defines found in original source go here.
//Please keep (relatively) alphabetical. Haxe will throw a fit if a var gets defined later,
//but used earlier...
class Extern
{
	public static var FRACBITS:Int = 16;
	public static var FRACUNIT:Fixed = 1 << FRACBITS;
	public static var FLOATSPEED = (FRACUNIT * 4);
	
	public static var MAXHEALTH = 100;
	public static var MAXINT:Int = 0x7fffffff;
	public static var MAXPLAYERS:Int = 4;
	public static var MAXSPECIALCROSS:Int = 8;
	public static var MELEERANGE:Fixed = 64 * FRACUNIT;
	public static var MININT:Int = 0x80000000;
	
	public static var numspechit:Int;
	
	public static var SECTORS:Sector;
	public static var spechit:Vector<LineDef> = new Vector(8);
	
	public static var tmfloorz:Fixed;
	
	public static var validcount:Int = 1;
	public static var VIEWHEIGHT = (41 * FRACUNIT);
	
}