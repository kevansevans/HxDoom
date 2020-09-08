package hxdoom.enums.eng;


/**
 * Describe values of the needed cardinal directions to describe sprite directions. One provided as integers, and one provided as strings.
 * @author Kaelan
 */
enum abstract Direction(Int) from Int
{
	var East:Int = 1;
	var NorthEast:Int = 1 << 2;
	var North:Int = 1 << 3;
	var NorthWest:Int = 1 << 4;
	var West:Int = 1 << 5;
	var SouthWest:Int = 1 << 6;
	var South:Int = 1 << 7;
	var SouthEast:Int = 1 << 8;
	var NoDirection:Int;
	var NumDirs:Int;
}