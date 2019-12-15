package;

#if sys
import sys.FileSystem;
import sys.io.File;
import haxe.io.Bytes;
#end

#if js
import js.Browser;
#end

import lime.utils.Bytes;
import lime.utils.Assets;
import lime.app.Application;
import lime.graphics.RenderContext;

import hxdoom.Engine;
import render.Scene;


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
		#if sys
		hxdoom.setBaseIwad(File.getBytes("./IWADS/DOOM1.WAD"), "DOOM1.WAD");
		#elseif js
		var waddata = Assets.loadBytes("IWADS/DOOM1.WAD");
		waddata.onComplete(function(data:Bytes):Bytes {
			hxdoom.setBaseIwad(data, "DOOM1.WAD");
			hxdoom.loadMap(0);
			wadsLoaded = true;
			return data;
		});
		#end
		
		#if !js
		hxdoom.loadMap(0);
		
		wadsLoaded = true;
		#end
	}
	public static function main () {
		
		var app = new Main ();
		return app.exec ();
		
	}
	public override function render (context:RenderContext):Void {
		
		if (!wadsLoaded) return;
		
		switch (context.type) {
			
			//Desktop and HTML5 with WebGL support
			case OPENGL, OPENGLES, WEBGL:
				
				if (renderScene == null) {
					renderScene = new Scene(context);
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
	
	override public function update(deltaTime:Int):Void 
	{
		super.update(deltaTime);
		
		if (renderScene != null) {
			renderScene.render();
		}
	}
}