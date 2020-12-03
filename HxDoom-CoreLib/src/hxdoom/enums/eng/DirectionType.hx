package;

/**
 * @author Kaelan
 * 
 * As of 03DEC2020, this code was borrowed from https://github.com/Olde-Skuul/doom3do/blob/5713f6fd2a66338e0135d41e297de963652371af/source/doom.h#L161
 */
enum abstract DirectionType(Int) from Int
{
	var EAST:Int;
	var NORTH_EAST:Int;
	var NORTH:Int;
	var NORTH_WEST:Int;
	var WEST:Int;
	var SOUTH_WEST:Int;
	var SOUTH:Int;
	var SOUTH_EAST:Int;
	var NO_DIRECTION:Int;
	var NUMBER_DIRECTIONS:Int;
}