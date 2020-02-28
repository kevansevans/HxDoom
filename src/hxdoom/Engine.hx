package hxdoom;
import haxe.io.Bytes;
import haxe.ds.Map;
import hxdoom.com.CheatHandler;
import hxdoom.data.graphiclumps.Playpal;
import hxdoom.data.maplumps.SubSector;

import hxdoom.data.BSPMap;
import hxdoom.data.RootPack;
import hxdoom.com.Environment;

/**
 * ...
 * @author Kaelan
 */
class Engine 
{
	public static var IWADS:Map<String, RootPack>;
	public static var BASEIWAD:String;
	
	public static var CHEATS:CheatHandler;
	
	/*
	 * these vars are the accumulated data that's supplies to the engine. Using a Map<String, [type]> format,
	 * this allows it to mimic the same style of namespace overriding all opther sourceports use, at the same
	 * time allowing new assets to occupy their own name space.
	 */
	public static var WADLIST:Map<String, RootPack>;
	public static var MAPLIST:Map<String, BSPMap>;
	public static var MAPALIAS:Array<String>;
	public static var PLAYPAL:Playpal;
	
	public static var ACTIVEMAP:BSPMap;
	
	var mapindex:Int = 0;
	
	public function new() 
	{
		IWADS = new Map();
		WADLIST = new Map();
		MAPLIST = new Map();
		MAPALIAS = new Array();
		
		CHEATS = new CheatHandler();
	}
	public function loadMap(_index:Int) {
		ACTIVEMAP = MAPLIST[MAPALIAS[_index]].copy();
		ACTIVEMAP.buildNodes(ACTIVEMAP.nodes.length - 1);
		Environment.NEEDS_TO_REBUILD_AUTOMAP = true;
	}
	public function setBaseIwad(_data:Bytes, _name:String) {
		IWADS[_name] = new RootPack(_data, _name, true);
		BASEIWAD = _name;
		
		for (bsp in IWADS[_name].maps) {
			MAPLIST[bsp.name] = bsp;
			MAPALIAS[mapindex] = bsp.name;
			++mapindex;
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
	
	public static inline function log(_msg:String) {
		trace(_msg);
	}
}