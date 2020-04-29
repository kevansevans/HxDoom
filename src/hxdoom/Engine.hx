package hxdoom;
import haxe.Timer;
import haxe.io.Bytes;
import haxe.ds.Map;
import hxdoom.common.CheatHandler;
import hxdoom.core.GameCore;
import hxdoom.core.IOCore;
import hxdoom.core.RenderCore;
import hxdoom.core.SoundCore;
import hxdoom.lumps.graphic.Playpal;
import hxdoom.lumps.map.SubSector;

import hxdoom.core.BSPMap;
import hxdoom.lumps.Iwad;
import hxdoom.common.Environment;

/**
 * ...
 * @author Kaelan
 */

class Engine 
{
	public static var IWADS:Map<String, Iwad>;
	public static var BASEIWAD:Null<String>;
	
	public static var CHEATS:CheatHandler;
	
	/*
	 * these vars are the accumulated data that's supplies to the engine. Using a Map<String, [type]> format,
	 * this allows it to mimic the same style of namespace overriding all opther sourceports use, at the same
	 * time allowing new assets to occupy their own name space.
	 */
	public static var WADLIST:Map<String, Iwad>;
	public static var MAPLIST:Map<String, BSPMap>;
	public static var MAPALIAS:Array<String>;
	public static var PLAYPAL:Playpal;
	
	public static var ACTIVEMAP:BSPMap;
	
	public static var RENDER:RenderCore;
	public static var GAME:GameCore;
	public static var IO:IOCore;
	public static var SOUND:SoundCore;
	
	public static var LOADMAP:Int -> Void;
	
	var mapindex:Int = 0;
	
	public function new() 
	{
		IWADS = new Map();
		WADLIST = new Map();
		MAPLIST = new Map();
		MAPALIAS = new Array();
		
		GAME = new GameCore();
		IO = new IOCore();
		
		CHEATS = new CheatHandler();
		
		LOADMAP = loadMap;
		
		setDefaultCVARS();
	}
	
	public function loadMap(_index:Int) {
		GAME.stop();
		var maploaded:Bool = IWADS[BASEIWAD].loadMap(_index);
		if (maploaded) {
			ACTIVEMAP.build();
			if (RENDER != null) {
				RENDER.initScene();
			}
		} else {
			//resume normal operation
		}
		GAME.start();
	}
	
	public function loadWad(_data:Bytes, _name:String) {
		
		var isIwad:Bool = _data.getString(0, 4) == "IWAD";
		
		//if (isIwad) {
			if (BASEIWAD == null) {
				IWADS[_name] = new Iwad(_data, _name);
				BASEIWAD = _name;
			}
		//} else {
			
		//}
	}
	
	function setDefaultCVARS() 
	{
		CVarCore.setNewCVar(EnvName.AUTOMAP_MODE, CVarType.CBool, false);
		CVarCore.setNewCVar(EnvName.AUTOMAP_ZOOM, CVarType.CFloat, 0.001);
		CVarCore.setNewCVar(EnvName.CHEAT_DEGREELESS, CVarType.CBool, false);
		CVarCore.setNewCVar(EnvName.CHEAT_TRUEGOD, CVarType.CBool, false);
		CVarCore.setNewCVar(EnvName.CHEAT_NOCLIP, CVarType.CBool, false);
		CVarCore.setNewCVar(EnvName.PLAYER_FOV, CVarType.CInt, 90);
		CVarCore.setNewCVar(EnvName.PLAYER_MOVING_FORWARD, CVarType.CBool, false);
		CVarCore.setNewCVar(EnvName.PLAYER_MOVING_BACKWARD, CVarType.CBool, false);
		CVarCore.setNewCVar(EnvName.PLAYER_STRAFING_LEFT, CVarType.CBool, false);
		CVarCore.setNewCVar(EnvName.PLAYER_STRAFING_RIGHT, CVarType.CBool, false);
		CVarCore.setNewCVar(EnvName.PLAYER_TURNING_LEFT, CVarType.CBool, false);
		CVarCore.setNewCVar(EnvName.PLAYER_TURNING_RIGHT, CVarType.CBool, false);
		CVarCore.setNewCVar(EnvName.PLAYER_VIEW_HEIGHT, CVarType.CInt, 41);
		CVarCore.setNewCVar(EnvName.SCREEN_DISTANCE_FROM_VIEWER, CVarType.CInt, 160);
	}
	
	public static inline function log(_msg:String) {
		trace(_msg);
	}
}