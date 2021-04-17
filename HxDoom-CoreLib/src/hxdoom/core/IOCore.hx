package hxdoom.core;

import hxdoom.core.GameCore;
import hxdoom.enums.data.Defaults;
import hxdoom.enums.data.HXDKeyCode;

/**
 * ...
 * @author Kaelan
 */

class IOCore
{
	public static var IGNORE_SHIFT:Bool = true;
	public static var SHIFT_IS_DOWN:Bool = false;
	
	//This structure should allow for multiple binds to be attached to an action
	public var keyPressAction:Map<Int, Array<Void -> Void>>;
	public var keyReleaseAction:Map<Int, Array<Void -> Void>>;
	
	public function new() 
	{
		keyPressAction = new Map();
		keyReleaseAction = new Map();
	}
	
	public function keyPress(_keyCode:Int) {
		
		switch (GameCore.STATE) {
			
			case IN_GAME :
				
				switch(_keyCode) {
					case HXDKeyCode.TAB : 
						CVarCore.setCVar(Defaults.AUTOMAP_MODE, !CVarCore.getCvar(Defaults.AUTOMAP_MODE));
						
					case HXDKeyCode.W_UPPER | HXDKeyCode.W_LOWER | HXDKeyCode.UP_ARROW :
						CVarCore.setCVar(Defaults.PLAYER_MOVING_FORWARD, true);
						
					case HXDKeyCode.S_UPPER | HXDKeyCode.S_LOWER | HXDKeyCode.DOWN_ARROW :
						CVarCore.setCVar(Defaults.PLAYER_MOVING_BACKWARD, true);
						
					case HXDKeyCode.A_UPPER | HXDKeyCode.A_LOWER :
						CVarCore.setCVar(Defaults.PLAYER_STRAFING_LEFT, true);
						
					case HXDKeyCode.D_UPPER | HXDKeyCode.D_LOWER :
						CVarCore.setCVar(Defaults.PLAYER_STRAFING_RIGHT, true);
						
					case HXDKeyCode.SHIFT :
						CVarCore.setCVar(Defaults.PLAYER_HOLDING_RUN, true);
						
					case HXDKeyCode.LEFT_ARROW :
						CVarCore.setCVar(Defaults.PLAYER_TURNING_LEFT, true);
						
					case HXDKeyCode.RIGHT_ARROW :
						CVarCore.setCVar(Defaults.PLAYER_TURNING_RIGHT, true);
						
					default :
						trace(_keyCode);
				}
			default :
				
		}
		
	}
	public function keyRelease(_keyCode:Int) {
		
		switch (GameCore.STATE) {
			
			case IN_GAME :
				
				switch(_keyCode) {
					case HXDKeyCode.W_UPPER | HXDKeyCode.W_LOWER | HXDKeyCode.UP_ARROW :
						CVarCore.setCVar(Defaults.PLAYER_MOVING_FORWARD, false);
						
					case HXDKeyCode.S_UPPER | HXDKeyCode.S_LOWER | HXDKeyCode.DOWN_ARROW :
						CVarCore.setCVar(Defaults.PLAYER_MOVING_BACKWARD, false);
						
					case HXDKeyCode.A_UPPER | HXDKeyCode.A_LOWER :
						CVarCore.setCVar(Defaults.PLAYER_STRAFING_LEFT, false);
						
					case HXDKeyCode.D_UPPER | HXDKeyCode.D_LOWER :
						CVarCore.setCVar(Defaults.PLAYER_STRAFING_RIGHT, false);
						
					case HXDKeyCode.SHIFT :
						CVarCore.setCVar(Defaults.PLAYER_HOLDING_RUN, false);
						
					case HXDKeyCode.LEFT_ARROW :
						CVarCore.setCVar(Defaults.PLAYER_TURNING_LEFT, false);
						
					case HXDKeyCode.RIGHT_ARROW :
						CVarCore.setCVar(Defaults.PLAYER_TURNING_RIGHT, false);
						
				}
				
			default :
		}
	}
	
	function keyCharToInt(keyChar:String):Int
	{
		return 0;
	}
}