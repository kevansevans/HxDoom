package hxdoom;
import haxe.display.Protocol.InitializeParams;
import haxe.io.Bytes;
import haxe.ds.Map;

import hxdoom.wad.BSPMap;
import hxdoom.wad.Pack;

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
	
	public static var ACTIVEMAP:BSPMap;
	
	public function new() 
	{
		IWADS = new Map();
		WADLIST = new Map();
		MAPLIST = new Map();
	}
	public function loadMap(_index:Int) {
		IWADS[BASEIWAD].loadMap(_index);
	}
	public function setBaseIwad(_data:Bytes, _name:String) {
		IWADS[_name] = new Pack(_data, _name, true);
		BASEIWAD = _name;
		
		for (bsp in IWADS[_name].maps) {
			MAPLIST[bsp.name] = bsp;
		}
	}
	//we'll figure this out later.
	public function makeFrakenWad() {
		/*
		 * function to combine all mapdata into singular pack.
		 */
	}
}