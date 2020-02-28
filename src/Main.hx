package;

import lime.ui.KeyModifier;
import lime.ui.MouseWheelMode;
import render.gl.GLHandler;

import haxe.io.Bytes;
import lime.ui.KeyCode;


#if (windows || linux || macos || osx)
import sys.FileSystem;
import sys.io.File;
#end

#if js
import js.Browser;
#end

import lime.utils.Bytes;
import lime.utils.Assets;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.ui.KeyCode;

import hxdoom.Engine;
import hxdoom.com.Environment;

class Main extends Application 
{
	var wadsLoaded:Bool = false;
	
	var gl_scene:GLHandler;
	
	var hxdoom:Engine;
	
	public function new () {
		super ();
		
		hxdoom = new Engine();
		
		/*
		 * We're going to assume an iwad picker of some sorts has been made already
		 */ 
		#if android
		macro throw "android deployment not yet understood XoX";
		//App crashes when loading in a wad. Doesn't crash when using the JS method, but crashes when the data
		//is handled in engine side of things
		#elseif (windows || linux || macos || osx)
		hxdoom.setBaseIwad(File.getBytes("./IWADS/DOOM1.WAD"), "DOOM1.WAD");
		
		hxdoom.loadMap(0);
		
		wadsLoaded = true;
		#elseif (js)
		var waddata = Assets.loadBytes("IWADS/DOOM1.WAD");
		waddata.onComplete(function(data:Bytes):Bytes {
			hxdoom.setBaseIwad(data, "DOOM1.WAD");
			hxdoom.loadMap(0);
			wadsLoaded = true;
			return data;
		});
		#end
	}
	public static function main () {
		
		var app = new Main ();
		return app.exec ();
		
	}
	public override function render (context:RenderContext):Void {
		
		if (!wadsLoaded) return;
		
		switch (context.type) {
			
			//Desktop, Android, and HTML5 with WebGL support
			case OPENGL, OPENGLES, WEBGL:
				
				if (gl_scene == null) {
					gl_scene = new GLHandler(context, window);
					gl_scene.programMapGeometry.buildMapGeometry();
				}
				
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
	
	override public function onWindowCreate():Void 
	{
		super.onWindowCreate();
		
		window.frameRate = 120;
		
		window.warpMouse(Std.int(window.width / 2), Std.int(window.height / 2));
	}
	
	override public function onWindowResize(width:Int, height:Int):Void 
	{
		super.onWindowResize(width, height);
		
		window.warpMouse(Std.int(window.width / 2), Std.int(window.height / 2));
		gl_scene.resize();
	}
	
	override public function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyUp(keyCode, modifier);
		
		switch(keyCode) {
			
			case KeyCode.TAB | KeyCode.SPACE :
				Environment.IS_IN_AUTOMAP = !Environment.IS_IN_AUTOMAP;
				
				Environment.NEEDS_TO_REBUILD_AUTOMAP = true;
				
			case KeyCode.NUMBER_1 :
				hxdoom.loadMap(0);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_2 :
				hxdoom.loadMap(1);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_3 :
				hxdoom.loadMap(2);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_4 :
				hxdoom.loadMap(3);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_5 :
				hxdoom.loadMap(4);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_6 :
				hxdoom.loadMap(5);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_7 :
				hxdoom.loadMap(6);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_8 :
				hxdoom.loadMap(7);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_9 :
				hxdoom.loadMap(8);
				gl_scene.programMapGeometry.buildMapGeometry();
				
			case KeyCode.LEFT:
				Environment.PLAYER_TURNING_LEFT = false;
			case KeyCode.RIGHT :
				Environment.PLAYER_TURNING_RIGHT = false;
			case KeyCode.UP | KeyCode.W :
				Environment.PLAYER_MOVING_FORWARD = false;
			case KeyCode.DOWN | KeyCode.S :
				Environment.PLAYER_MOVING_BACKWARD = false;
			
			default :
				
		}
	}
	
	override public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyDown(keyCode, modifier);
		
		switch(keyCode) {
			case KeyCode.LEFT :
				Environment.PLAYER_TURNING_LEFT = true;
			case KeyCode.RIGHT :
				Environment.PLAYER_TURNING_RIGHT = true;
			case KeyCode.UP | KeyCode.W :
				Environment.PLAYER_MOVING_FORWARD = true;
			case KeyCode.DOWN | KeyCode.S :
				Environment.PLAYER_MOVING_BACKWARD = true;
			default :
				
		}
		
		
		#if !html5
		Engine.CHEATS.logKeyStroke(String.fromCharCode(keyCode));
		#end
		
		//JS throws errors here, find an alternative method?
	}
	
	override public function onMouseWheel(deltaX:Float, deltaY:Float, deltaMode:MouseWheelMode):Void 
	{
		super.onMouseWheel(deltaX, deltaY, deltaMode);
		
		var mxa:Float = 
		Environment.AUTOMAP_ZOOM += (0.0001 * deltaY) / (1 / Environment.AUTOMAP_ZOOM / 200);
	}
	
	var ticks:Int = 0;
	var framecount = 0;
	var mscount = 0;
	
	override public function update(deltaTime:Int):Void 
	{
		super.update(deltaTime);
		
		ticks += deltaTime;
		
		if (ticks >= 1000 / 35) {
			
			if (Environment.PLAYER_MOVING_FORWARD) {
				Engine.ACTIVEMAP.actors_players[0].move(5);
			}
			
			if (Environment.PLAYER_MOVING_BACKWARD) {
				Engine.ACTIVEMAP.actors_players[0].move(-5);
			}
			
			if (Environment.PLAYER_TURNING_LEFT) {
				Engine.ACTIVEMAP.actors_players[0].angle += 1;
			}
			
			if (Environment.PLAYER_TURNING_RIGHT) {
				Engine.ACTIVEMAP.actors_players[0].angle -= 1;
			}
			
			ticks = 0;
			
			Engine.ACTIVEMAP.getVisibleSegments();
			
		}
		
		if (gl_scene != null) {
			gl_scene.render_scene();
		}
		
		framecount += 1;
		mscount += deltaTime;
		if (framecount >= window.frameRate) {
			var average = mscount / window.frameRate;
			//trace("FPS: " + Std.int(1000 / average));
			framecount = 0;
			mscount = 0;
		}
	}
	
	var mousex:Float = 0;
	var mousey:Float = 0;
	
	override public function onMouseMove(_x:Float, _y:Float):Void 
	{
		super.onMouseMove(_x, _y);
		
		#if js
		return;
		#end
		
		if (!Environment.IS_IN_AUTOMAP) {
			mousex = _x;
			mousey = _y;
			
			var distx = (window.width / 2) - mousex;
			var disty = (window.height / 2) - mousey;
			
			distx *= 0.25;
			disty *= 0.25;
			
			if (Engine.ACTIVEMAP != null) {
				Engine.ACTIVEMAP.actors_players[0].angle += distx;
				Engine.ACTIVEMAP.actors_players[0].pitch += disty;
			}
			
			window.warpMouse(Std.int(window.width / 2), Std.int(window.height / 2));
			
			if (gl_scene != null) {
				gl_scene.programMapGeometry.buildMapGeometry();
			}
		}
	}
}