package hxdoom.enums.data;

/**
 * @author Kaelan
 * 
 * Contains the default CVar values needed.
 */
enum abstract Defaults(String) from String {
	/**
	 * Bool, default false. Game engines typically only allow single IWADS to be loaded, this serves as a buffer to allow the engine to catch if a second IWAD has been attempted to load.
	 */
	var ALLOW_MULTIPLE_IWADS:String;
	/**
	 * Bool, default True. Shareware wads are not allowed to be modded. This flag is set to false when a shareware IWAD is loaded.
	 */
	var ALLOW_PWADS:String;
	/**
	 * Bool, default false. Is player viewing the automap?
	 */
	var AUTOMAP_MODE:String;
	/**
	 * Bool, default false. Automap lines rotate with player to match the direction they're facing.
	 */
	var AUTOMAP_ROTATES_WITH_PLAYER:String;
	/**
	 * Float, default 0.001. Zoom level of automap.
	 */
	var AUTOMAP_ZOOM:String;
	/**
	 * Bool, default false.
	 */
	var CHEAT_NOCLIP:String;
	/**
	 * Bool, default false.
	 */
	var CHEAT_DEGREELESS:String;
	/**
	 * Bool, default false.
	 */
	var CHEAT_TRUEGOD:String;
	
	/**
	 * Bool, set to true to read map data in Hexen format.
	 */
	var HEXEN_FORMAT:String;
	
	/**
	 * Bool, default false. Has this core been overriden?
	 */
	var OVERRIDE_CHEATS:String;
	/**
	 * Bool, default false. Has this core been overriden?
	 */
	var OVERRIDE_GAME:String;
	/**
	 * Bool, default false. Has this core been overriden?
	 */
	var OVERRIDE_IO:String;
	/**
	 * Bool, default false. Has this core been overriden?
	 */
	var OVERRIDE_PROFILE:String;
	/**
	 * Bool, default false. Has this core been overriden?
	 */
	var OVERRIDE_RENDER:String;
	/**
	 * Bool, default false. Has this core been overriden?
	 */
	var OVERRIDE_SOUND:String;
	/**
	 * Bool, default false. Has this core been overriden?
	 */
	var OVERRIDE_TEXTURES:String;
	/**
	 * Bool, default false. Has this core been overriden?
	 */
	var OVERRIDE_LEVELS:String;
	
	/**
	 * Int, default 90.
	 */
	var PLAYER_FOV:String;
	/**
	 * Bool, default false.
	 */
	var PLAYER_HOLDING_RUN:String;
	/**
	 * Int, default 41.
	 */
	var PLAYER_VIEW_HEIGHT:String;
	/**
	 * Bool, default false.
	 */
	var PLAYER_MOVING_FORWARD:String;
	/**
	 * Bool, default false.
	 */
	var PLAYER_MOVING_BACKWARD:String;
	/**
	 * Bool, default false.
	 */
	var PLAYER_STRAFING_LEFT:String;
	/**
	 * Bool, default false.
	 */
	var PLAYER_STRAFING_RIGHT:String;
	/**
	 * Bool, default false.
	 */
	var PLAYER_TURNING_LEFT:String;
	/**
	 * Bool, default false.
	 */
	var PLAYER_TURNING_RIGHT:String;
	
	/**
	 * Int, default 160.
	 */
	var SCREEN_DISTANCE_FROM_VIEWER:String;
	
	/**
	 * Bool, default false.
	 */
	var WADS_LOADED:String;
}