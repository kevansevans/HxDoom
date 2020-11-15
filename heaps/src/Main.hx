package;

import haxe.PosInfos;
import haxe.io.Bytes;
import hxd.Res;
import hxd.Window;
import hxd.res.DefaultFont;
import hxdgamelib.profiles.DoomProfile;
import hxdoom.Engine;
import hxd.App;
import hxd.File;
import hxdoom.component.Actor;
import scene.MapScene;
import hxd.Event;
import hxd.Key;

import hxdoom.core.action.Enemy;

import h2d.Console;

#if hl
import hl.UI;
import sys.FileSystem;
#end

/**
 * ...
 * @author Kaelan
 */
class Main extends App
{
	public static var hxdoom:Engine;
	public static var scene3D:MapScene;
	
	var con:Console;
	var con_vis:Bool = false;
	
	var screen:hxd.Window;
	
	override function init() {
		
		#if (!debug && hl)
		UI.closeConsole();
		#end
		
		Res.initEmbed();
		
		Console.HIDE_LOG_TIMEOUT = 60;
		con = new Console(DefaultFont.get(), s2d);
		con.hide();
		addConsoleCommands();
		
		h3d.mat.MaterialSetup.current = new h3d.mat.PbrMaterialSetup();
		
		hxdoom = new Engine();
		
		hxdoom.setcore_profile(new DoomProfile());
		
		hxdoom.addWadBytes(Res.shareware.DOOM1.entry.getBytes(), "DOOM1.WAD");
		//hxdoom.addWadBytes(Res.shareware.E1M1UDMF.entry.getBytes(), "E1M1UDMF.WAD");
		
		Engine.TEXTURES.loadPlaypal();
		scene3D = new MapScene(s3d);
		
		hxdoom.loadMap("E1M1");
		
		scene3D.buildMap();
		
		screen = hxd.Window.getInstance();
		screen.addEventTarget(onEventkey);
		
    }
	
	function addConsoleCommands() 
	{
		/*Engine.log = function(_msg:Array<String>, ?_pos:PosInfos) {
			for (message in _msg) {
				con.log(message);
				con.log([_pos.lineNumber + "", _pos.className, _pos.fileName].join(" "), 0xFF0000);
			}
		}*/
		
		var arg1:ConsoleArgDesc = {	t : AString, 
									opt : false, 
									name : "Map Marker" };
		con.addCommand("map", "map [map marker name], loads map from given marker name", [arg1], loadMap);
		
	}
	
	#if hl
	function loadWad(_wad:String)
	{
		
		if (FileSystem.isDirectory("./wads")) {
			if (FileSystem.exists("./wads/" + _wad)) {
				File.load("./wads/" + _wad.toUpperCase(), function(_bytes:Bytes) {
					hxdoom.addWadBytes(_bytes, _wad.toUpperCase());
					Engine.TEXTURES.loadPlaypal();
					scene3D = new MapScene(s3d);
				});
			} else {
				Engine.log(['Cannot find $_wad in local wad directory']);
			}
		} else {
			Engine.log(['Cannot find local wad directory ./wads']);
		}
	}
	#end
	
	function loadMap(_marker:String)
	{
		Engine.LOADMAP(_marker.toUpperCase());
		scene3D.disposeMap();
		scene3D.buildMap();
		Engine.GAME.tick();
	}
	
	public function onEventkey(e:Event):Void 
	{
		
		switch (e.kind) {
			case EKeyDown :
				Engine.IO.keyPress(e.keyCode);
			case EKeyUp :
				Engine.IO.keyRelease(e.keyCode);
				
				if (e.keyCode == 192) {
					if (con_vis) {
						con_vis = false;
						con.hide();
					} else {
						con_vis = true;
						con.show();
					}
					
				}
			case EWheel :
			
			default :
				
		}
		
	}
	var acc_delta:Float = 0;
	override function update(dt:Float) 
	{
		super.update(dt);
		
		if (scene3D != null) scene3D.update();
		
		if (!con_vis) {
			
			acc_delta += dt;
			
			if (acc_delta >= 1 / 35) {
				acc_delta = 0;
				
				if (scene3D != null) Engine.GAME.tick();
			}
			
		}
		
	}
    static function main() {
        new Main();
    }
}