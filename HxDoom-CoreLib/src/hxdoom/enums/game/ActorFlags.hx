package  hxdoom.enums.game;

/**
 * @author Kaelan
 * 
 */
enum abstract ActorFlags(Int) from Int //p_mobj.h
{
	var SPECIAL:Int = 1 << 1;
	var SOLID:Int = 1 << 2;
	var SHOOTABLE:Int = 1 << 3;
	var NOSECTOR:Int = 1 << 4;
	var NOBLOCKMAP:Int = 1 << 5;
	var AMBUSH:Int = 1 << 6;
	var JUSTHIT:Int = 1 << 7;
	var JUSTATTACKED:Int = 1 << 8;
	var SPAWNCEILING:Int = 1 << 9;
	var NOGRAVITY:Int = 1 << 10;
	var DROPOFF:Int = 1 << 11;
	var PICKUP:Int = 1 << 12;
	var NOCLIP:Int = 1 << 13;
	var SLIDE:Int = 1 << 14;
	var FLOAT:Int = 1 << 15;
	var TELEPORT:Int = 1 << 16;
	var MISSILE:Int = 1 << 17;
	var DROPPED:Int = 1 << 18;
	var SHADOW:Int = 1 << 19;
	var NOBLOOD:Int = 1 << 20;
	var CORPSE:Int = 1 << 21;
	var INFLOAT:Int = 1 << 22;
	var COUNTKILL:Int = 1 << 23;
	var COUNTITEM:Int = 1 << 24;
	var SKULLFLY:Int = 1 << 25;
	var NOTDMATCH:Int = 1 << 26;
	var TRANSLATION:Int = 0xc000000;
}