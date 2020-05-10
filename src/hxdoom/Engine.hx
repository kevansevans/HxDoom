package hxdoom;
import haxe.Timer;
import haxe.io.Bytes;
import haxe.ds.Map;
import hxdoom.utils.enums.CVarType;

import hxdoom.utils.enums.Defaults;
import hxdoom.core.*;
import hxdoom.lumps.map.SubSector;

/**
 * ...
 * @author Kaelan
 */

class Engine 
{
	/*
	 * these vars are the accumulated data that's supplies to the engine. Using a Map<String, [type]> format,
	 * this allows it to mimic the same style of namespace overriding all opther sourceports use, at the same
	 * time allowing new assets to occupy their own name space.
	 */
	
	public static var CHEATS:CheatCore;
	public static var WADDATA:WadCore;
	
	public static var ACTIVEMAP:BSPMap;
	
	public static var RENDER:RenderCore;
	public static var GAME:GameCore;
	public static var IO:IOCore;
	public static var SOUND:SoundCore;
	
	public static var LOADMAP:String -> Void;
	
	var mapindex:Int = 0;
	
	public function new() 
	{
		WADDATA = new WadCore();
		GAME = new GameCore();
		IO = new IOCore();
		
		CHEATS = new CheatCore();
		
		LOADMAP = loadMap;
		
		setDefaultCVARS();
	}
	
	public function loadMap(_mapMarker:String) {
		GAME.stop();
		
		var mapLoaded = WADDATA.loadMap(_mapMarker);
		if (mapLoaded) {
			Engine.ACTIVEMAP.build();
			if (RENDER != null) {
				RENDER.initScene();
			}
		}
		
		GAME.start();
	}
	
	public function addWad(_wadBytes:Bytes, _wadName:String) {
		WADDATA.addWad(_wadBytes, _wadName);
	}
	
	function setDefaultCVARS() 
	{
		CVarCore.setNewCVar(Defaults.AUTOMAP_MODE, 					CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.AUTOMAP_ZOOM, 					CVarType.CFloat, 0.001);
		CVarCore.setNewCVar(Defaults.CHEAT_DEGREELESS, 				CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.CHEAT_TRUEGOD, 				CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.CHEAT_NOCLIP, 					CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.PLAYER_FOV, 					CVarType.CInt, 90);
		CVarCore.setNewCVar(Defaults.PLAYER_MOVING_FORWARD, 		CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.PLAYER_MOVING_BACKWARD, 		CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.PLAYER_STRAFING_LEFT, 			CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.PLAYER_STRAFING_RIGHT, 		CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.PLAYER_TURNING_LEFT, 			CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.PLAYER_TURNING_RIGHT, 			CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.PLAYER_VIEW_HEIGHT, 			CVarType.CInt, 41);
		CVarCore.setNewCVar(Defaults.SCREEN_DISTANCE_FROM_VIEWER, 	CVarType.CInt, 160);
	}
	
	public static inline function log(_msg:String) {
		trace(_msg);
	}
}