package hxdoom.enums.eng;


/**
 * Describe values of the needed cardinal directions to describe sprite directions. One provided as integers, and one provided as strings.
 * @author Kaelan
 */
enum abstract Direction(Int) from Int
{
	var East:Int;
	var NorthEast:Int;
	var North:Int;
	var NorthWest:Int;
	var West:Int;
	var SouthWest:Int;
	var South:Int;
	var SouthEast:Int;
	var NoDirection:Int;
	var NumDirs:Int;
}