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
import packages.actors.TypeID;
import packages.actors.TypeGroup;

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
	var wads:Array<WadData>;
	
	static var iwad_chosen:Int = 0;
	static var map_scale_inv:Int = 5;
	static var map_to_draw:Int = 0;
	
	var draw:Sprite;
	var mapsprite:Sprite;
	
	public function new() 
	{
		super();
		
		wads = new Array<WadData>();	
		
		draw = new Sprite();
		mapsprite = new Sprite();
		addChild(draw);
		draw.addChild(mapsprite);
		mapsprite.scaleY = -1;
		
		var wad:Bytes;
		
		//could turn this into a single loop (no conditionals), but I want to make sure each target uses the shortest loop available.
		#if sys
		//if Sys, then app can simply scan the wads directory and load those
		for (a in FileSystem.readDirectory("./wads")) {
			wad = File.getBytes("./wads/" + a);
			var isIwad:Bool = wad.getString(0, 4) == "IWAD";
			wads.push(new WadData(wad, a, isIwad));
		}
		#else
		//If not sys, then target either does not allow it or has a different method of loading files.
		for (a in Assets.list()) {
			if (a.lastIndexOf("wads/") == 0) wad = Assets.getBytes(a);
			else continue;
			var isIwad:Bool = wad.getString(0, 4) == "IWAD";
			wads.push(new WadData(wad, a, isIwad));
		}
		#end
		
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
	
	//This function is likely to be deprecated in favor of a proper automap, it's just for debug purposes. Dunno when that will happen.
	function redraw()
	{
		map_to_draw = Std.int(wads[0].mapindex.length * Math.random());
		wads[0].loadMap(map_to_draw);
		
		var _map = wads[0].activemap;
		
		draw.x = draw.y = 0;
		draw.scaleX = draw.scaleY = 1;
		
		mapsprite.graphics.clear();
		mapsprite.graphics.lineStyle(1, 0xFFFFFF);
		
		var xoff = _map.offset_x;
		var yoff = _map.offset_y;
		
		for (a in _map.linedefs) {
			mapsprite.graphics.moveTo((_map.vertexes[a.start].x + xoff) / map_scale_inv, (_map.vertexes[a.start].y + yoff) / map_scale_inv);
			mapsprite.graphics.lineTo((_map.vertexes[a.end].x + xoff) / map_scale_inv, (_map.vertexes[a.end].y + yoff) / map_scale_inv);
		}
		
		for (a in _map.things) {
			switch (a.type) {
				case TypeID.P_PLAYERONE | TypeID.P_PLAYERTWO | TypeID.P_PLAYERTHREE | TypeID.P_PLAYERFOUR:
					mapsprite.graphics.lineStyle(1, 0x00FF00);
				case 	TypeID.M_SPIDERMASTERMIND | TypeID.M_FORMERSERGEANT | TypeID.M_CYBERDEMON |
						TypeID.M_DEADFORMERHUMAN | TypeID.M_DEADFORMERSERGEANT | TypeID.M_DEADIMP | TypeID.M_DEADDEMON |
						TypeID.M_DEADCACODEMON | TypeID.M_DEADLOSTSOUL | TypeID.M_SPECTRE | TypeID.M_ARCHVILE |
						TypeID.M_FORMERCOMMANDO | TypeID.M_REVENANT | TypeID.M_MANCUBUS | TypeID.M_ARACHNOTRON |
						TypeID.M_HELLKNIGHT | TypeID.M_PAINELEMENTAL | TypeID.M_COMMANDERKEEN | TypeID.M_WOLFSS |
						TypeID.M_SPAWNSPOT | TypeID.M_BOSSBRAIN | TypeID.M_BOSSSHOOTER | TypeID.M_IMP |
						TypeID.M_DEMON | TypeID.M_BARONOFHELL | TypeID.M_FORMERTROOPER | TypeID.M_CACODEMON |
						TypeID.M_LOSTSOUL
						:
							mapsprite.graphics.lineStyle(1, 0xFF0000);
				case 	TypeID.I_AMMOCLIP | TypeID.I_BACKPACK | TypeID.I_BERSERK | TypeID.I_BLUEARMOR |
						TypeID.I_BLUEKEYCARD | TypeID.I_BLUESKULLKEY | TypeID.I_BOXOFAMMO | TypeID.I_BOXOFROCKETS |
						TypeID.I_BOXOFSHELLS | TypeID.I_CELLCHARGE | TypeID.I_CELLCHARGEPACK | TypeID.I_COMPUTERMAP |
						TypeID.I_GREENARMOR | TypeID.I_HEALTHPOTION | TypeID.I_INVISIBILITY | TypeID.I_INVULNERABILITY |
						TypeID.I_LIGHTAMPLIFICATIONVISOR | TypeID.I_MEDIKIT | TypeID.I_MEGASPHERE | TypeID.I_RADIATIONSUIT |
						TypeID.I_REDKEYCARD | TypeID.I_REDSKULLKEY | TypeID.I_ROCKET | TypeID.I_SHOTGUNSHELLS |
						TypeID.I_SOULSPHERE | TypeID.I_SPIRITARMOR | TypeID.I_STIMPACK | TypeID.I_YELLOWKEYCARD |
						TypeID.I_YELLOWSKULLKEY
						:
							mapsprite.graphics.lineStyle(1, 0x00CCFF);
				default :
					mapsprite.graphics.lineStyle(1, 0xFFFFFF);
			}
			mapsprite.graphics.drawCircle((a.xpos + xoff) / map_scale_inv, (a.ypos + yoff) / map_scale_inv, 2);
		}
		
		mapsprite.y = mapsprite.height;
	}

}
