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
import packages.wad.maplumps.Segment;

import packages.actors.TypeID;
import packages.wad.Pack;
import packages.wad.LevelID;

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
	var subSectorsprite:Sprite;
	
	public function new() 
	{
		super();
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load wad data here
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		var wad:Bytes;
		wads = new Array<Pack>();	
		
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
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//OpenFL junk here
		//
		//Could be beneficial to replaced this with a different Haxe API.
		//Likely candidate is Kha for it's wider range of deployment capabilities than OpenFL and default
		//hardware rendering. Issue currently stands that I don't know how to arbitrarily load files
		//into the program. Kind of defeats the purpose of a Doom engine if I can't arbitrarily tack on
		//more assets outside of the code.
		//
		//Using OpenFL because I'm most comfortable with that.
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		draw = new Sprite();
		mapsprite = new Sprite();
		subSectorsprite = new Sprite();
		addChild(draw);
		draw.addChild(mapsprite);
		draw.addChild(subSectorsprite);
		
		mapsprite.scaleX /= map_scale_inv;
		mapsprite.scaleY /= map_scale_inv * -1;
		
		subSectorsprite.scaleX /= map_scale_inv;
		subSectorsprite.scaleY /= map_scale_inv * -1;
		
		stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
			switch (e.keyCode) {
				case Keyboard.NUMBER_0 :
					wads[0].loadMap(10); //this causes crash
				case Keyboard.NUMBER_1 :
					wads[0].loadMap(LevelID.E1M1);
				case Keyboard.NUMBER_2 :
					wads[0].loadMap(LevelID.E1M2);
				case Keyboard.NUMBER_3 :
					wads[0].loadMap(LevelID.E1M3);
				case Keyboard.NUMBER_4 :
					wads[0].loadMap(LevelID.E1M4);
				case Keyboard.NUMBER_5 :
					wads[0].loadMap(LevelID.E1M5);
				case Keyboard.NUMBER_6 :
					wads[0].loadMap(LevelID.E1M6);
				case Keyboard.NUMBER_7 :
					wads[0].loadMap(LevelID.E1M7);
				case Keyboard.NUMBER_8 :
					wads[0].loadMap(LevelID.E1M8);
				case Keyboard.NUMBER_9 :
					wads[0].loadMap(LevelID.E1M9);
			}
			debug_draw();
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
			debug_draw();
		}
	}
	
	function debug_draw()
	{
		var _map = wads[0].activeMap;
		
		draw.x = draw.y = 0;
		draw.scaleX = draw.scaleY = 1;
		
		var xoff = _map.offset_x;
		var yoff = _map.offset_y;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Drawing code start
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		mapsprite.graphics.clear();
		mapsprite.graphics.lineStyle(2, 0xFFFFFF);
		for (line in wads[0].linedefs) {
			mapsprite.graphics.moveTo(line.start.xpos + xoff, line.start.ypos + yoff);
			mapsprite.graphics.lineTo(line.end.xpos + xoff, line.end.ypos + yoff);
		}
		
		mapsprite.y = mapsprite.height;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Drawing code end
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}

/*
 *	struct Vertex
	{
		vec2 position;
		int frontsector;
		int backsector;
		int wallpart;
		int vertexnum;
	} 
 */
