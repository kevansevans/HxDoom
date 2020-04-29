package hxdoom.common;
import haxe.ds.Map;
import haxe.ds.StringMap;

#if js
import js.Browser;
#end

/**
 * ...
 * @author Kaelan
 */
class Environment 
{
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//Functions
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public static function GlobalThrowError(_msg:String) {
		#if !js
		throw _msg + "\n" + platform() + "\n\nReport issues to: https://github.com/kevansevans/HxDoom";
		#else
		Browser.alert(_msg + "\n" + platform() + "\n\nReport issues to: https://github.com/kevansevans/HxDoom");
		throw _msg + "\n" + platform() + "\n\nReport issues to: https://github.com/kevansevans/HxDoom";
		#end
	}
	static function platform():String {
		#if sys
		return Sys.systemName();
		#elseif js
		return Browser.navigator.userAgent;
		#elseif (flash || air)
		return "Flash Player";
		#end
	}
}

enum abstract EnvName(String) from String {
	var AUTOMAP_MODE:String;
	var AUTOMAP_ROTATES_WITH_PLAYER:String;
	var AUTOMAP_ZOOM:String;
	var CHEAT_NOCLIP:String;
	var CHEAT_DEGREELESS:String;
	var CHEAT_TRUEGOD:String;
	var NEEDS_TO_REBUILD_AUTOMAP:String;
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