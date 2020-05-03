package hxdoom.utils.enums;

/**
 * @author Kaelan
 * 
 * Contains the default CVar values needed.
 */
enum abstract Defaults(String) from String {
	var AUTOMAP_MODE:String;
	var AUTOMAP_ROTATES_WITH_PLAYER:String;
	var AUTOMAP_ZOOM:String;
	
	var CHEAT_NOCLIP:String;
	var CHEAT_DEGREELESS:String;
	var CHEAT_TRUEGOD:String;
	
	var PLAYER_FOV:String;
	var PLAYER_VIEW_HEIGHT:String;
	var PLAYER_MOVING_FORWARD:String;
	var PLAYER_MOVING_BACKWARD:String;
	var PLAYER_STRAFING_LEFT:String;
	var PLAYER_STRAFING_RIGHT:String;
	var PLAYER_TURNING_LEFT:String;
	var PLAYER_TURNING_RIGHT:String;
	
	var SCREEN_DISTANCE_FROM_VIEWER:String;
}