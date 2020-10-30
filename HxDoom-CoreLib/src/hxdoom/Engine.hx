package hxdoom;

import haxe.PosInfos;
import haxe.io.Bytes;
import haxe.ds.Map;
import haxe.macro.Expr;
import hxdoom.enums.data.CVarType;
import hxdoom.component.LevelMap;
import hxdoom.lumps.map.*;

import hxdoom.enums.data.Defaults;
import hxdoom.core.*;
import hxdoom.lumps.map.SubSector;
import hxdoom.enums.eng.KeyLump;
import hxdoom.enums.eng.DataLump;
import hxdoom.enums.EnumTool;

import haxe.Int64;

/**
 * Engine.hx acts as the hub class for accessing data. It contains "cores" that can be utilized for wad data manipulation.
 * Cores can be overriden by the developers to modify behavior. Some of these cores are mandatory to change in order to use.
 * @see https://kevansevans.github.io/HxDoom/demo/
 * @author Kaelan
 */

class Engine 
{
	/**
	 * Handles wad loading and parsing
	 **/
	public static var WADDATA(get, null):WadCore;
	/**
	 * Sets behavior based on the first IWAD provided
	 **/
	public static var PROFILE(get, null):ProfileCore;
	/**
	 * Handles render behavior
	 **/
	public static var RENDER(get, null):RenderCore;
	/**
	 * Handles game behavior, not yet implemented
	 **/
	public static var GAME(get, null):GameCore;
	/**
	 * Handles input and output behavior
	 **/
	public static var IO(get, null):IOCore;
	/**
	 * Handles sound processing
	 **/
	public static var SOUND(get, null):SoundCore;
	/**
	 * Handles texture reading and building
	 **/
	public static var TEXTURES(get, null):TextureCore;
	/**
	 * Handles general map related behaviors
	 */
	public static var LEVELS(get, null):LevelCore;
	/**
	 * Function to call when loading a map. Can be overriden to change behavior.
	 **/
	public static var LOADMAP:String -> Bool;
	
	var mapindex:Int = 0;
	
	public function new() 
	{
		WADDATA = new WadCore();
		GAME = new GameCore();
		IO = new IOCore();
		RENDER = new RenderCore();
		SOUND = new SoundCore();
		PROFILE = new ProfileCore();
		TEXTURES = new TextureCore();
		LEVELS = new LevelCore();
		LOADMAP = loadMap;
		
		setDefaultCVARS();
		
		Reader.keyLumpList = EnumTool.toStringArray(KeyLump);
		Reader.dataLumpList = EnumTool.toStringArray(DataLump);
	}
	/**
	 * Setter to override GameCore behavior. Changes CVar flag when overriden. Optional.
	 * @param	_cheats Providing 'null' will reset to default core
	 */
	public function setcore_game(?_game:GameCore) {
		if (_game == null) {
			GAME = new GameCore();
			CVarCore.setCVar(Defaults.OVERRIDE_GAME, false);
		} else {
			GAME = _game;
			CVarCore.setCVar(Defaults.OVERRIDE_GAME, true);
		}
	}
	/**
	 * Setter to override IOCore behavior. Changes CVar flag when overriden. Optional.
	 * @param	_cheats Providing 'null' will reset to default core
	 */
	public function setcore_IO(?_IO:IOCore) {
		if (_IO == null) {
			IO = new IOCore();
			CVarCore.setCVar(Defaults.OVERRIDE_IO, false);
		} else {
			IO = _IO;
			CVarCore.setCVar(Defaults.OVERRIDE_IO, true);
		}
	}
	/**
	 * Setter to override ProfileCore behavior. Changes CVar flag when overriden. Optional.
	 * @param	_cheats Providing 'null' will reset to default core
	 */
	public function setcore_profile(?_profile:ProfileCore) {
		if (_profile == null) {
			PROFILE = new ProfileCore();
			CVarCore.setCVar(Defaults.OVERRIDE_PROFILE, false);
		} else {
			PROFILE = _profile;
			CVarCore.setCVar(Defaults.OVERRIDE_PROFILE, true);
		}
	}
	/**
	 * Setter to override RenderCore behavior. Changes CVar flag when overriden. Mandatory to draw a scene.
	 * @param	_cheats Providing 'null' will reset to default core
	 */
	public function setcore_render(?_render:RenderCore) {
		if (_render == null) {
			RENDER = new RenderCore();
			CVarCore.setCVar(Defaults.OVERRIDE_RENDER, false);
		} else {
			RENDER = _render;
			CVarCore.setCVar(Defaults.OVERRIDE_RENDER, true);
		}
	}
	/**
	 * Setter to override TextureCore behavior. Changes CVar flag when overriden. Optional.
	 * @param	_cheats Providing 'null' will reset to default core
	 */
	public function setcore_textures(?_textures:TextureCore) {
		if (_textures == null) {
			TEXTURES = new TextureCore();
			CVarCore.setCVar(Defaults.OVERRIDE_TEXTURES, false);
		} else {
			TEXTURES = _textures;
			CVarCore.setCVar(Defaults.OVERRIDE_TEXTURES, true);
		}
	}
	public function setcore_levels(?_levels:LevelCore) {
		if (_levels == null) {
			LEVELS = new LevelCore();
			CVarCore.setCVar(Defaults.OVERRIDE_LEVELS, false);
		} else {
			LEVELS = _levels;
			CVarCore.setCVar(Defaults.OVERRIDE_LEVELS, true);
		}
	}
	/**
	 * Default function to load a map that's set to Engine.LOADMAP()
	 * @param	_mapMarker String denoting map marker directory
	 */
	public function loadMap(_mapMarker:String) {
		GAME.stop();
		
		var mapLoaded = LEVELS.loadMap(_mapMarker);
		if (mapLoaded) {
			Engine.LEVELS.currentMap.build();
			if (RENDER != null) {
				RENDER.initScene();
			}
		}
		
		GAME.start();
		
		return mapLoaded;
	}
	/**
	 * Adds and parses wad into memory.
	 * @param	_wadBytes Wad as bytes
	 * @param	_wadName Name of wad
	 */
	public function addWadBytes(_wadBytes:Bytes, _wadName:String) {
		WADDATA.addWadFromBytes(_wadBytes, _wadName);
	}
	public function addWadString(_wadString:String, _wadname:String) {
		WADDATA.addWadFromString(_wadString, _wadname);
	}
	/**
	 * Sets default CVar environment vars.
	 */
	public function setDefaultCVARS() 
	{
		CVarCore.setNewCVar(Defaults.ALLOW_MULTIPLE_IWADS, 			CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.ALLOW_PWADS, 					CVarType.CBool, 	true);
		CVarCore.setNewCVar(Defaults.AUTOMAP_MODE, 					CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.AUTOMAP_ZOOM, 					CVarType.CFloat, 	0.001);
		
		CVarCore.setNewCVar(Defaults.CHEAT_DEGREELESS, 				CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.CHEAT_TRUEGOD, 				CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.CHEAT_NOCLIP, 					CVarType.CBool, 	false);
		
		CVarCore.setNewCVar(Defaults.HEXEN_FORMAT, 					CVarType.CBool, 	false, toggleHexenMapFormat);
		
		CVarCore.setNewCVar(Defaults.OVERRIDE_CHEATS, 				CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.OVERRIDE_GAME, 				CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.OVERRIDE_IO, 					CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.OVERRIDE_PROFILE, 				CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.OVERRIDE_RENDER, 				CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.OVERRIDE_SOUND, 				CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.OVERRIDE_TEXTURES,				CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.OVERRIDE_LEVELS,				CVarType.CBool, 	false);
		
		CVarCore.setNewCVar(Defaults.PLAYER_FOV, 					CVarType.CInt, 		90);
		CVarCore.setNewCVar(Defaults.PLAYER_MOVING_FORWARD, 		CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.PLAYER_MOVING_BACKWARD, 		CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.PLAYER_STRAFING_LEFT, 			CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.PLAYER_STRAFING_RIGHT, 		CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.PLAYER_TURNING_LEFT, 			CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.PLAYER_TURNING_RIGHT, 			CVarType.CBool, 	false);
		CVarCore.setNewCVar(Defaults.PLAYER_VIEW_HEIGHT, 			CVarType.CInt, 		41);
		
		CVarCore.setNewCVar(Defaults.SCREEN_DISTANCE_FROM_VIEWER, 	CVarType.CInt, 		160);
		
		CVarCore.setNewCVar(Defaults.WADS_LOADED, 					CVarType.CBool, 	false);
	}
	
	public function toggleHexenMapFormat() {
		
		var hexen = CVarCore.getCvar(Defaults.HEXEN_FORMAT);
		
		if (hexen) {
			
			LineDef.BYTE_SIZE = LineDefHexen.BYTE_SIZE;
			
			Reader.readLinedef = Reader.readHexenLinedef;
			
		} else {
			
			LineDef.BYTE_SIZE = 14;
			Thing.BYTE_SIZE = 10;
			
			Reader.readLinedef = Reader.readLinedefDefault;
			Reader.readThing = Reader.readThingDefault;
		}
	}
	
	/**
	 * Placeholder for future engine logging
	 * @param	_msg
	 */
	public static var log:(Array<String>, ?PosInfos) -> Void = logDefault;
	public static function logDefault(_msg:Array<String>, ?_pos:PosInfos) {
		trace("From: " + _pos);
		for (msg in _msg) {
			trace(msg);
		}
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
	
	static function get_PROFILE():ProfileCore 
	{
		return PROFILE;
	}
	
	static function get_LEVELS():LevelCore
	{
		return LEVELS;
	}
	
	static function get_TEXTURES():TextureCore 
	{
		return TEXTURES;
	}
}