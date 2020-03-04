package hxdoom;
import haxe.Timer;
import haxe.io.Bytes;
import haxe.ds.Map;
import hxdoom.common.CheatHandler;
import hxdoom.core.Render;
import hxdoom.lumps.graphic.Playpal;
import hxdoom.lumps.map.SubSector;

import hxdoom.core.BSPMap;
import hxdoom.core.Render;
import hxdoom.lumps.Iwad;
import hxdoom.common.Environment;

/**
 * ...
 * @author Kaelan
 */

enum EngineState {
	START_MENU;
	IN_GAME;
	IN_GAME_MENU;
	IN_GAME_PAUSE; //Pause/Break key is a different pause from pressing escape
}
class Engine 
{
	public static var IWADS:Map<String, Iwad>;
	public static var BASEIWAD:String;
	
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
	public static var RENDER:Render;
	
	public static var gamelogic:Void -> Void;
	
	public static var STATE:EngineState;
	
	var timer:Timer;
	
	var mapindex:Int = 0;
	
	public function new() 
	{
		IWADS = new Map();
		WADLIST = new Map();
		MAPLIST = new Map();
		MAPALIAS = new Array();
		
		CHEATS = new CheatHandler();
		
		RENDER = new Render();
		
		gamelogic = tick;
		
		STATE = IN_GAME;
	}
	
	public function start() {
		
		timer = new Timer(Std.int(1000 / 35));
		timer.run = gamelogic;
	}
	
	public function loadMap(_index:Int) {
		ACTIVEMAP = MAPLIST[MAPALIAS[_index]].copy();
		ACTIVEMAP.buildNodes(ACTIVEMAP.nodes.length - 1);
	}
	
	public function loadWad(_data:Bytes, _name:String) {
		
		var isIwad:Bool = _data.getString(0, 4) == "IWAD";
		
		if (isIwad) {
			IWADS[_name] = new Iwad(_data, _name);
			BASEIWAD = _name;
			for (bsp in IWADS[_name].maps) {
				MAPLIST[bsp.name] = bsp;
				MAPALIAS[mapindex] = bsp.name;
				++mapindex;
			}
		} else {
			
		}
	}
	//we'll call this function when pwad support works
	public function makeFrakenWad() {
		for (wad in WADLIST) {
			for (map in wad.maps) {
				if (MAPLIST[map.name] == null) {
					MAPALIAS[mapindex] = map.name;
					++mapindex;
				}
				MAPLIST[map.name] = map;
			}
		}
		
	}
	
	public function tick() {
		
		switch (STATE) {
			
			case IN_GAME:
				if (Environment.PLAYER_MOVING_FORWARD) {
					Engine.ACTIVEMAP.actors_players[0].move(5);
				}
				if (Environment.PLAYER_MOVING_BACKWARD) {
					Engine.ACTIVEMAP.actors_players[0].move(-5);
				}
				if (Environment.PLAYER_TURNING_LEFT) {
					Engine.ACTIVEMAP.actors_players[0].angle += 1;
				}
				if (Environment.PLAYER_TURNING_RIGHT) {
					Engine.ACTIVEMAP.actors_players[0].angle -= 1;
				}
				
				if (ACTIVEMAP != null) RENDER.setVisibleSegments();
				
			case START_MENU :
				
			case IN_GAME_MENU :
				
			case IN_GAME_PAUSE :
				
			default :
				
		}
	}
	
	public static inline function log(_msg:String) {
		trace(_msg);
	}
}