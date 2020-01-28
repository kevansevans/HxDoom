package hxdoom.com;
import hxdoom.abstracts.CheatCode;

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
	//Variables
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//Integers and Floats
	public static var PLAYER_FOV:Int = 90;
	public static var AUTOMAP_ZOOM(default, set) = 0.001;
	
	//Bools. Make sure to name all vars in the form of a true/false question
	public static var IS_IN_AUTOMAP:Bool = false;
	public static var NEEDS_TO_REBUILD_AUTOMAP:Bool = false;
	
	//Arrays
	public static var CHEAT_KEYLOGGER:CheatCode = new Array<String>();
	
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
	
	static function set_PLAYER_FOV(value:Int):Int 
	{
		PLAYER_FOV = value;
		if (PLAYER_FOV > 360) PLAYER_FOV = 360; 
		if (PLAYER_FOV < 0) PLAYER_FOV = 0; 
		return PLAYER_FOV;
	}
	
	static function set_AUTOMAP_ZOOM(value:Float):Float
	{
		AUTOMAP_ZOOM = value;
		if (AUTOMAP_ZOOM < 0.0001) AUTOMAP_ZOOM = 0.0001;
		if (AUTOMAP_ZOOM > 0.01) AUTOMAP_ZOOM = 0.01;
		return AUTOMAP_ZOOM;
	}
}