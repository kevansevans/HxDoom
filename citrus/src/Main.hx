package;

import game.profiles.doom.DoomShareware;
import haxe.Http;
import haxe.io.Bytes;
import haxe.Json;
import haxe.Timer;

import lime.graphics.RenderContext;
import lime.net.HTTPRequest;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.MouseWheelMode;
import lime.ui.WindowAttributes;

import render.limeGL.GLHandler;

import hxdoom.Engine;
import hxdoom.core.CVarCore;
import hxdoom.enums.data.Defaults;

#if sys
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
#else
import lime.utils.Assets;
#end

#if js
import js.Browser;
#end

import lime.utils.Bytes;
import lime.app.Application;
import lime.ui.KeyCode;

class Main extends Application 
{
	var hxdoom:Engine;
	var env_path:Null<String>;
	var timer:Timer;
	
	#if sys
	var pathlist:Map<String, String>;
	#end
	
	public function new () {
		super();
	}
	
	override public function onWindowCreate():Void 
	{
		super.onWindowCreate();
		
		window.frameRate = 35;
		
		#if sys
		getwads();
		launchGame(File.getBytes(env_path + "/DOOM1.WAD"));
		#else
		var wadbytes = Assets.loadBytes("IWADS/DOOM1.WAD");
		wadbytes.onComplete(function(data:Bytes):Bytes {
			launchGame(data);
			return data;
		});
		#end
	}
	
	function getwads()
	{
		
		var wadlist:Array<String> = new Array();
		
		#if !sys
		
		var shareware = Assets.getBytes("IWADS/DOOM1.WAD");
		
		#else
		
		var templist:Array<String> = new Array();
		pathlist = new Map();
		
		var env = Sys.environment();
		env_path = env["DOOMWADDIR"];
		
		if (env_path != null) {
			templist = FileSystem.readDirectory(env_path);
		} else {
			env_path = "./wads";
			if (!FileSystem.isDirectory(env_path)) FileSystem.createDirectory(env_path);
		}
		
		return;
		
		for (wad in templist) {
			var name = wad.toUpperCase();
			if (name.lastIndexOf(".WAD") != -1) {
				var iwad:Bool = verify_iwad(File.read(env_path + "/" + wad, true), wad);
				if (iwad) {
					pathlist[wad] = env_path + "/" + wad;
				}
			}
		}
		
		#end
	}
	
	function verify_iwad(read:FileInput, _name:String):Bool
	{
		var file = read;
		var header:Null<String>;
		try {
			header = file.readString(4);
		} catch (_msg:String) {
			return false;
		}
		if (header == "IWAD") return true;
		else return false;
	}
	
	override public function render(context:RenderContext):Void 
	{
		if (hxdoom == null) return;
		
		if (!CVarCore.getCvar(Defaults.WADS_LOADED)) return;
		
		if (!CVarCore.getCvar(Defaults.OVERRIDE_RENDER)) {
			hxdoom.setcore_render(new GLHandler(context, this.window));
			Engine.RENDER.initScene();
		}
		
		switch (context.type) {
			
			//Desktop, Android, and HTML5 with WebGL support
			case OPENGL, OPENGLES, WEBGL:
				
				if (Engine.LEVELS.currentMap != null) Engine.RENDER.setVisibleSegments();
				Engine.RENDER.render_scene();
				
			//HTML5 without WebGL support
			case CANVAS :
				#if js
					Browser.alert("Canvas renderer not yet supported, many apologies");
				#end
				
			case DOM :
				throw "I have no idea what DOM is or how you're running it, but it's not supported here unfortunately. Many apologies";
			case FLASH :
				throw "This throw is only noticeable in Adobe Air. Flash rendering is not yet supported. Many Apologies";
			default:
				throw "Render context not supported";
		}
	}
	
	function launchGame(_wadbytes:Bytes) {
		hxdoom = new Engine();
		hxdoom.addWadBytes(_wadbytes, "DOOM1.WAD");
		
		hxdoom.setcore_profile(new DoomShareware());
		
		Engine.LEVELS.startEpisode(0);
		
		timer = new Timer(Std.int(1000 / 35));
		timer.run = Engine.GAME.tick;
	}
	
	override public function onWindowResize(width:Int, height:Int):Void 
	{
		super.onWindowResize(width, height);
		
		Engine.RENDER.resize(width, height);
	}
	
	override public function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		Engine.IO.keyRelease(keyCode);
	}
	
	override public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		Engine.IO.keyPress(keyCode);
	}
}