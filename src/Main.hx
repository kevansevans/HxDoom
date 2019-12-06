package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.ui.Keyboard;
#if sys
import sys.FileSystem;
import sys.io.File;
#elseif js

#end
import haxe.io.Bytes;
import packages.wad.maplumps.Segment;
import packages.wad.maplumps.Vertex;

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
 * Idealistic goals
 * 		Some form of modding support
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
	var thingprite:Sprite;
	
	var infotext:TextField;
	
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
		/*
		 * OpenFL junk starts here. Using OpenFL because I'm most comfortable with that.
		 *
		 * Could be beneficial to replaced this with a different Haxe framework.
		 * Likely candidate is Kha for it's wider range of deployment capabilities than OpenFL and default
		 * hardware rendering. Issue currently stands that Kha feels like a complete mess to me and has
		 * been incredibly frustrating for me to use. I might set this source up to allow several different
	 	 * frameworks as a last resprt and build around each of their capabilities, thought this will 
		 * definitely pile onto the confusion of which build to download.
		 *
		 * So to summarize, my options are
		 * - Switch to Kha
		 *		- Wider range of targets
	 	 * 		- Utilizes GPU acceleration by default across all targets
		 * 		- Difficult for me to personally use
		 * - Stick to openFL
		 * 		- Narrower range of targets but covers most bases
		 *		- Familiar API
		 *		- No clue how to utilize GPU acceleration
		 * - Use lime
		 * 		- OpenFL rests on Lime
		 * 		- Lime has direct OpenGL access
		 * 		- I don't know how to use OpenGL
		 * - Heaps
		 * 		- Extremely narrow deployment range, Hashlink (desktop) and HTML5 only
		 *		- Android is possible but not officially supported
		 * 		- GPU acclerated from the getgo
		 * 		- Unfamiliar with it's api
		 * - Conditional backends
		 * 		- God are you insane?
		 * - Raw Haxe
		 * 		- ??????????????????????????????????????????????
		 * 		- i have no idea help
		*/
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		draw = new Sprite();
		mapsprite = new Sprite();
		subSectorsprite = new Sprite();
		thingprite = new Sprite();
		addChild(draw);
		draw.addChild(mapsprite);
		draw.addChild(subSectorsprite);
		draw.addChild(thingprite);
		
		mapsprite.scaleX /= map_scale_inv;
		mapsprite.scaleY /= map_scale_inv * -1;
		
		subSectorsprite.scaleX /= map_scale_inv;
		subSectorsprite.scaleY /= map_scale_inv * -1;
		
		thingprite.scaleX /= map_scale_inv;
		thingprite.scaleY /= map_scale_inv * -1;
		
		infotext = new TextField();
		addChild(infotext);
		infotext.textColor = 0xFFFFFF;
		infotext.text = "HxDoom extremely early build, using DOOM1.wad (Shareware)\nPress 1 - 9 to change map\nPress 0 to cause deliberate crash\nClick and drag to move map\nScroll to change scale\nAny other key to reset.";
		infotext.width = infotext.textWidth;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Event listeners - openFL only
		////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Keyboard - openFL only
		////////////////////////////////////////////////////////////////////////////////////////////////////
		stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
			switch (e.keyCode) {
				case Keyboard.NUMBER_0 :
					wads[0].loadMap( -1); //this causes crash
					debug_draw();
				case Keyboard.NUMBER_1 :
					wads[0].loadMap(LevelID.E1M1);
					debug_draw();
				case Keyboard.NUMBER_2 :
					wads[0].loadMap(LevelID.E1M2);
					debug_draw();
				case Keyboard.NUMBER_3 :
					wads[0].loadMap(LevelID.E1M3);
					debug_draw();
				case Keyboard.NUMBER_4 :
					wads[0].loadMap(LevelID.E1M4);
					debug_draw();
				case Keyboard.NUMBER_5 :
					wads[0].loadMap(LevelID.E1M5);
					debug_draw();
				case Keyboard.NUMBER_6 :
					wads[0].loadMap(LevelID.E1M6);
					debug_draw();
				case Keyboard.NUMBER_7 :
					wads[0].loadMap(LevelID.E1M7);
					debug_draw();
				case Keyboard.NUMBER_8 :
					wads[0].loadMap(LevelID.E1M8);
					debug_draw();
				case Keyboard.NUMBER_9 :
					wads[0].loadMap(LevelID.E1M9);
					debug_draw();
				case Keyboard.T :
					thingprite.visible = !thingprite.visible;
				default :
					debug_draw();
			}
		});
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Mouse Listeners - openFL only
		////////////////////////////////////////////////////////////////////////////////////////////////////
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
		//openFL Drawing code start
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		mapsprite.graphics.clear();
		mapsprite.graphics.lineStyle(2, 0xFFFFFF);
		for (line in wads[0].linedefs) {
			mapsprite.graphics.moveTo(line.start.xpos + xoff, line.start.ypos + yoff);
			mapsprite.graphics.lineTo(line.end.xpos + xoff, line.end.ypos + yoff);
		}
		
		draw.removeChild(thingprite);
		thingprite = new Sprite();
		draw.addChild(thingprite);
		thingprite.scaleX /= map_scale_inv;
		thingprite.scaleY /= map_scale_inv * -1;
		
		var index = 0;
		for (actor in wads[0].activeMap.actorsprites) {
			thingprite.addChild(actor);
			actor.x = wads[0].things[index].xpos + xoff;
			actor.y = wads[0].things[index].ypos + yoff;
			++index;
		}
		
		subSectorsprite.graphics.clear();
		var tempSubVer:Array<Vertex> = new Array();
		for (segs in _map.segments) {
			subSectorsprite.graphics.lineStyle(2, Std.int(Math.random() * 0xFFFFFF));
			subSectorsprite.graphics.beginFill(Std.int(Math.random() * 0xFFFFFF));
			subSectorsprite.graphics.moveTo(segs.start.xpos + xoff, segs.start.ypos + yoff);
			subSectorsprite.graphics.lineTo(segs.end.xpos + xoff, segs.end.ypos + yoff);
		}
		
		mapsprite.y = mapsprite.height;
		thingprite.y = mapsprite.y;
		subSectorsprite.y = mapsprite.y;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//openFL Drawing code end
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
