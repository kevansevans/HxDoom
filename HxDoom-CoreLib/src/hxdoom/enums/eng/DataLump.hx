package hxdoom.enums.eng;

/**
 * Lumps whos name does not directly indicate their intended purpose.
 * @author Kaelan
 */
enum abstract DataLump(String) from String 
{
	var GRAPHIC:String;
	var SOUNDFX:String;
	var SOUNDPC:String;
	var MIDIMUS:String;
	var UNKNOWN:String;
	var MARKER:String;
}