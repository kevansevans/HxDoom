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

import packages.WadData;

/**
 * ...
 * @author Kaelan
 */
class Main extends Sprite 
{
	var wads:Array<WadData>;
	
	static var iwad_chosen:Int = 0;
	static var map_scale_inv:Int = 5;
	static var map_to_draw:Int = 0;
	
	var draw:Sprite;
	
	public function new() 
	{
		super();
		
		wads = new Array<WadData>();	
		
		draw = new Sprite();
		addChild(draw);
		
		var wad:Bytes;
		
		//could turn this into a single loop (no conditionals), but I want to make sure each target uses the shortest loop available.
		#if sys
			for (a in FileSystem.readDirectory("./wads")) {
				wad = File.getBytes("./wads/" + a);
		#elseif js
			for (a in Assets.list()) {
				if (a.lastIndexOf("wads/") == 0) wad = Assets.getBytes(a);
				else continue;
		#end
			var isIwad:Bool = wad.getString(0, 4) == "IWAD";
			wads.push(new WadData(wad, a, isIwad));
		}
		
		stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.R) redraw();
		});
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent) {
			draw.scaleX += e.delta / 10;
			draw.scaleY += e.delta / 10;
			if (draw.scaleX <= 0.1) draw.scaleX = draw.scaleY = 0.1;
			if (draw.scaleX >= 20) draw.scaleX = draw.scaleY = 20;
		});
		stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
			draw.startDrag();
		});
		stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent) {
			draw.stopDrag();
		});
		
		if (wads.length > 0) {
			redraw();
		} else {
			trace("No wad data collected");
		}
	}
	
	function redraw()
	{
		map_to_draw = Std.int(wads[0].mapindex.length * Math.random());
		wads[0].loadMap(map_to_draw);
		
		var map = wads[0].activemap;
		
		draw.x = draw.y = 0;
		draw.scaleX = draw.scaleY = 1;
		
		draw.graphics.clear();
		draw.graphics.lineStyle(1, 0xFFFFFF);
		
		var xoff = map.offset_x;
		var yoff = map.offset_y;
		
		for (a in map.linedefs) {
			draw.graphics.moveTo((map.vertexes[a.start].x + xoff) / map_scale_inv, (map.vertexes[a.start].y + yoff) / map_scale_inv);
			draw.graphics.lineTo((map.vertexes[a.end].x + xoff) / map_scale_inv, (map.vertexes[a.end].y + yoff) / map_scale_inv);
		}
	}

}
