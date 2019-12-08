package global;

#if js
import js.Browser;
#end

/**
 * ...
 * @author Kaelan
 */
class Common 
{
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//Variables
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public static var PLAYER_FOV(default, set):Int = 90; //Experiment with this not being inline
	
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
}