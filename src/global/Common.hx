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

	public function new() 
	{
		
	}
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
		#elseif (Flash || Air)
		return "Flash Player";
		#end
	}
}