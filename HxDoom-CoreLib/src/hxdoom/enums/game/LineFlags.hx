package hxdoom.enums.game;

/**
 * @author Kaelan
 * 
 * Line flags don't have a strictly built enum, so this enum will be built over time
 * as I find them.
 */
enum abstract LineFlags(Int) from Int 
{
	var TWOSIDED:Int = 4;
	var SECRET:Int = 32;
	var SOUNDBLOCK:Int = 64;
}