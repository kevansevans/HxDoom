package;

import lime.ui.KeyModifier;
import lime.ui.MouseWheelMode;

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
import render.gl.Scene;

class Main extends Application 
{
	var wadsLoaded:Bool = false;
	var renderScene:Scene;
	
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
				
				if (renderScene == null) {
					renderScene = new Scene(context, window);
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
	
	override public function onWindowResize(width:Int, height:Int):Void 
	{
		super.onWindowResize(width, height);
		
		
	}
	
	override public function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyUp(keyCode, modifier);
		
		switch(keyCode) {
			
			case KeyCode.TAB :
				Environment.IS_IN_AUTOMAP = !Environment.IS_IN_AUTOMAP;
				
				Environment.NEEDS_TO_REBUILD_AUTOMAP = true;
				
			case KeyCode.NUMBER_1 :
				hxdoom.loadMap(0);
			case KeyCode.NUMBER_2 :
				hxdoom.loadMap(1);
			case KeyCode.NUMBER_3 :
				hxdoom.loadMap(2);
			case KeyCode.NUMBER_4 :
				hxdoom.loadMap(3);
			case KeyCode.NUMBER_5 :
				hxdoom.loadMap(4);
			case KeyCode.NUMBER_6 :
				hxdoom.loadMap(5);
			case KeyCode.NUMBER_7 :
				hxdoom.loadMap(6);
			case KeyCode.NUMBER_8 :
				hxdoom.loadMap(7);
			case KeyCode.NUMBER_9 :
				hxdoom.loadMap(8);
			default :
				
		}
	}
	
	override public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyDown(keyCode, modifier);
		
		switch(keyCode) {
			case KeyCode.LEFT :
				Engine.ACTIVEMAP.actors_players[0].angle += 1;
			case KeyCode.RIGHT :
				Engine.ACTIVEMAP.actors_players[0].angle -= 1;
			case KeyCode.UP :
				Engine.ACTIVEMAP.actors_players[0].move(5);
			case KeyCode.DOWN :
				Engine.ACTIVEMAP.actors_players[0].move(-5);
			default :
				
		}
		trace(Environment.CHEAT_KEYLOGGER[0] = String.fromCharCode(keyCode));
	}
	
	override public function onMouseWheel(deltaX:Float, deltaY:Float, deltaMode:MouseWheelMode):Void 
	{
		super.onMouseWheel(deltaX, deltaY, deltaMode);
		
		Environment.AUTOMAP_ZOOM += (0.0001 * deltaY);
	}
	
	override public function update(deltaTime:Int):Void 
	{
		super.update(deltaTime);
		
		if (renderScene != null) {
			renderScene.render();
		}

	}
}