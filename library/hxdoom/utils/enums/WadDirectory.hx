package hxdoom.utils.enums;

/**
 * @author Kaelan
 */
enum abstract WadDirectory(String) from String
{
	var windows:String = "C:/DOOM/WADS";
	var linux:String = "~/usr/local/share/games/DOOM/WADS";
}