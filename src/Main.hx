package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
#if sys
import sys.FileSystem;
import sys.io.File;
#elseif js

#end
import haxe.io.Bytes;

import packages.actors.TypeID;
import packages.wad.Pack;

/**
 * ...
 * @author Kaelan
 * 
 * Realistic Goals: 
 * 		Maintain target deployment support. If it has a renderer, it must be deployable to that target.
 * 		- JS target needs to be able to tell the difference between shareware and commericial if hosted.
 */
class Main extends Sprite 
{
	var wads:Array<Pack>;
	
	static var iwad_chosen:Int = 0;
	static var map_scale_inv:Int = 2;
	static var map_to_draw:Int = 0;
	
	var draw:Sprite;
	var mapsprite:Sprite;
	var mapnode:Sprite;
	
	public function new() 
	{
		super();
		
		wads = new Array<Pack>();	
		
		draw = new Sprite();
		mapsprite = new Sprite();
		mapnode = new Sprite();
		addChild(draw);
		draw.addChild(mapsprite);
		addChild(mapnode);
		
		mapsprite.scaleX /= map_scale_inv;
		mapsprite.scaleY /= map_scale_inv * -1;
		
		var wad:Bytes;
		
		//could turn this into a single loop (no conditionals), but I want to make sure each target uses the shortest loop available.
		#if sys
		//if Sys, then app can simply scan the wads directory and load those
		for (a in FileSystem.readDirectory("./wads")) {
			wad = File.getBytes("./wads/" + a);
			var isIwad:Bool = wad.getString(0, 4) == "IWAD";
			wads.push(new Pack(wad, a, isIwad));
		}
		#else
		//If not sys, then target either does not allow it or has a different method of loading files.
		for (a in Assets.list()) {
			if (a.lastIndexOf("wads/") == 0) wad = Assets.getBytes(a);
			else continue;
			var isIwad:Bool = wad.getString(0, 4) == "IWAD";
			wads.push(new Pack(wad, a, isIwad));
		}
		#end
		
		wads[0].loadMap(0);
		
		
		stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.R) debug_draw();
		});
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent) {
			draw.scaleX += e.delta / 10;
			draw.scaleY += e.delta / 10;
			if (draw.scaleX <= 0.1) draw.scaleX = draw.scaleY = 0.1;
			if (draw.scaleX >= 20) draw.scaleX = draw.scaleY = 20;
			mapnode.scaleX = draw.scaleX;
			mapnode.scaleY = draw.scaleY;
		});
		stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
			draw.startDrag();
		});
		stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent) {
			draw.stopDrag();
		});
		
		if (wads.length > 0) {
			debug_draw();
		} else {
			trace("No wad data collected");
		}
	}
	
	function debug_draw()
	{
		map_to_draw = Std.int(wads[0].mapindex.length * Math.random());
		wads[0].loadMap(map_to_draw);
		
		var _map = wads[0].activemap;
		
		draw.x = draw.y = 0;
		draw.scaleX = draw.scaleY = 1;
		
		var xoff = _map.offset_x;
		var yoff = _map.offset_y;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Drawing code start
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		mapsprite.graphics.clear();
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Drawing code end
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		mapsprite.y = mapsprite.height;
	}
}
