package hxdoom;
import haxe.Timer;
import haxe.io.Bytes;
import haxe.ds.Map;
import hxdoom.common.CheatHandler;
import hxdoom.core.GameLogic;
import hxdoom.core.IOLogic;
import hxdoom.core.RenderLogic;
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
	
	public static var RENDER:RenderLogic;
	public static var GAME:GameLogic;
	public static var IO:IOLogic;
	
	var mapindex:Int = 0;
	
	public function new(_gameLogic:GameLogic, _ioLogic:IOLogic, _renderLogic:RenderLogic) 
	{
		IWADS = new Map();
		WADLIST = new Map();
		MAPLIST = new Map();
		MAPALIAS = new Array();
		
		GAME = _gameLogic;
		IO = _ioLogic;
		RENDER = _renderLogic;
		
		CHEATS = new CheatHandler();
	}
	
	public function loadMap(_index:Int) {
		ACTIVEMAP = MAPLIST[MAPALIAS[_index]].copy();
		ACTIVEMAP.buildNodes(ACTIVEMAP.nodes.length - 1);
	}
	
	public function loadWad(_data:Bytes, _name:String) {
		
		var isIwad:Bool = _data.getString(0, 4) == "IWAD";
		
		//if (isIwad) {
			IWADS[_name] = new Iwad(_data, _name);
			BASEIWAD = _name;
			for (bsp in IWADS[_name].maps) {
				MAPLIST[bsp.name] = bsp;
				MAPALIAS[mapindex] = bsp.name;
				++mapindex;
			}
		//} else {
			
		//}
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
	
	
	public static inline function log(_msg:String) {
		trace(_msg);
	}
}