package hxdoom.utils.enums;


/**
 * ...
 * @author Kaelan
 */
enum abstract CardInt(Int) from Int to Int {
	var EAST:Int = 0;
	var NORTHEAST:Int = 45;
	var NORTH:Int = 90;
	var NORTHWEST:Int = 135;
	var WEST:Int = 180;
	var SOUTHWEST:Int = 225;
	var SOUTH:Int = 270;
	var SOUTHEAST:Int = 315;
	//The sequel we've all been waiting for (But really just in case)
	var EAST2:Int = 360;
}
enum abstract CardString(String) from String to String {
	var EAST:String;
	var NORTHEAST:String;
	var NORTH:String;
	var NORTHWEST:String;
	var WEST:String;
	var SOUTHWEST:String;
	var SOUTH:String;
	var SOUTHEAST:String;
}