package hxdoom;
import haxe.io.Bytes;
import haxe.ds.Map;

import hxdoom.wad.BSPMap;
import hxdoom.wad.Pack;
import hxdoom.com.Environment;

/**
 * ...
 * @author Kaelan
 */
class Engine 
{
	public static var IWADS:Map<String, Pack>;
	public static var BASEIWAD:String;
	
	/*
	 * these vars are the accumulated data that's supplies to the engine. Using a Map<String, [type]> format,
	 * this allows it to mimic the same style of namespace overriding all opther sourceports use, at the same
	 * time allowing new assets to occupy their own name space.
	 */
	public static var WADLIST:Map<String, Pack>;
	public static var MAPLIST:Map<String, BSPMap>;
	public static var MAPALIAS:Array<String>;
	
	public static var ACTIVEMAP:BSPMap;
	
	var mapindex:Int = 0;
	
	public function new() 
	{
		IWADS = new Map();
		WADLIST = new Map();
		MAPLIST = new Map();
		MAPALIAS = new Array();
	}
	public function loadMap(_index:Int) {
		ACTIVEMAP = MAPLIST[MAPALIAS[_index]];
		Environment.NEEDS_TO_REBUILD_AUTOMAP = true;
	}
	public function setBaseIwad(_data:Bytes, _name:String) {
		IWADS[_name] = new Pack(_data, _name, true);
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
}