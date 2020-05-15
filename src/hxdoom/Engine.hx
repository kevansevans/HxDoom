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
	
	public static var CHEATS(get, null):CheatCore;
	public static var WADDATA(get, null):WadCore;
	
	public static var ACTIVEMAP:BSPMap;
	
	public static var RENDER(get, null):RenderCore;
	public static var GAME(get, null):GameCore;
	public static var IO(get, null):IOCore;
	public static var SOUND(get, null):SoundCore;
	
	public static var LOADMAP:String -> Void;
	
	var mapindex:Int = 0;
	
	public function new() 
	{
		WADDATA = new WadCore();
		GAME = new GameCore();
		IO = new IOCore();
		RENDER = new RenderCore();
		CHEATS = new CheatCore();
		SOUND = new SoundCore();
		
		LOADMAP = loadMap;
		
		setDefaultCVARS();
	}
	
	public function setcore_game(?_game:GameCore) {
		if (_game == null) {
			GAME = new GameCore();
			CVarCore.setCVar(Defaults.OVERRIDE_GAME, false);
		} else {
			GAME = _game;
			CVarCore.setCVar(Defaults.OVERRIDE_GAME, true);
		}
	}
	
	public function setcore_IO(?_IO:IOCore) {
		if (_IO == null) {
			IO = new IOCore();
			CVarCore.setCVar(Defaults.OVERRIDE_IO, false);
		} else {
			IO = _IO;
			CVarCore.setCVar(Defaults.OVERRIDE_IO, true);
		}
	}
	
	public function setcore_render(?_render:RenderCore) {
		if (_render == null) {
			RENDER = new RenderCore();
			CVarCore.setCVar(Defaults.OVERRIDE_RENDER, false);
		} else {
			RENDER = _render;
			CVarCore.setCVar(Defaults.OVERRIDE_RENDER, true);
		}
	}
	
	public function setcore_cheats(?_cheats:CheatCore) {
		if (_cheats == null) {
			CHEATS = new CheatCore();
			CVarCore.setCVar(Defaults.OVERRIDE_CHEATS, false);
		} else {
			CHEATS = _cheats;
			CVarCore.setCVar(Defaults.OVERRIDE_CHEATS, true);
		}
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
		CVarCore.setNewCVar(Defaults.ALLOW_MULTIPLE_IWADS, 			CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.ALLOW_PWADS, 					CVarType.CBool, true);
		CVarCore.setNewCVar(Defaults.AUTOMAP_MODE, 					CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.AUTOMAP_ZOOM, 					CVarType.CFloat, 0.001);
		
		CVarCore.setNewCVar(Defaults.CHEAT_DEGREELESS, 				CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.CHEAT_TRUEGOD, 				CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.CHEAT_NOCLIP, 					CVarType.CBool, false);
		
		CVarCore.setNewCVar(Defaults.OVERRIDE_CHEATS, 				CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.OVERRIDE_GAME, 				CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.OVERRIDE_IO, 					CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.OVERRIDE_RENDER, 				CVarType.CBool, false);
		CVarCore.setNewCVar(Defaults.OVERRIDE_SOUND, 				CVarType.CBool, false);
		
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
	
	static function get_CHEATS():CheatCore 
	{
		return CHEATS;
	}
	
	static function get_WADDATA():WadCore 
	{
		return WADDATA;
	}
	
	static function get_RENDER():RenderCore 
	{
		return RENDER;
	}
	
	static function get_GAME():GameCore 
	{
		return GAME;
	}
	
	static function get_IO():IOCore 
	{
		return IO;
	}
	
	static function get_SOUND():SoundCore 
	{
		return SOUND;
	}
	
	public static inline function log(_msg:String) {
		trace(_msg);
	}
}