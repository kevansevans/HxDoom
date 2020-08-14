package;

import haxe.Http;
import haxe.io.Bytes;
import haxe.Json;
import haxe.Timer;
import haxe.zip.Uncompress;
import haxe.zip.Entry;
import haxe.zip.Reader;

import lime.graphics.RenderContext;
import lime.net.HTTPRequest;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.MouseWheelMode;
import lime.ui.WindowAttributes;

import openfl.net.URLRequest;
import openfl.utils.ByteArray;

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
	
	#if sys
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
	
	var pendingdownload:Int = 0;
	
	function download_wads() {
		
		var env = Sys.environment();
		if (env_path == null) {
			env_path = Sys.programPath() + "/wads";
		}
		
		if (!FileSystem.isDirectory(env_path + "/downloads/")) FileSystem.createDirectory(env_path + "/downloads/");
		
		var freedoom_github = new Http("https://api.github.com/repos/freedoom/freedoom/releases/latest");
		//haxe you fucking crybaby
		freedoom_github.onData = function(_packet:String) {
			var data:Dynamic = Json.parse(_packet);
			for (index in 0...(Std.int(data.assets.length - 1))) {
				download_file(data.assets[index].browser_download_url, env_path + "/downloads/", data.assets[index].name);
			}
		}
		freedoom_github.onError = function(_packet:String) {
			return null;
		}
		freedoom_github.onStatus = function(_packet:Int) {
			trace(_packet);
		}
		freedoom_github.setHeader('User-Agent', 'CitrusDoom');
		freedoom_github.request();
		
		download_file('http://distro.ibiblio.org/pub/linux/distributions/slitaz/sources/packages/d/doom1.wad', env_path, "DOOM1.WAD");
	}
	
	function download_file(_url:String, _path:String, _name:String) {
		
		++pendingdownload;
		
		var file = File.write(_path + "/" + _name);
		var httpfile = new HTTPRequest<Bytes>(_url);
		httpfile.followRedirects = true;
		httpfile.load().onError(function (_msg) 
		{
			trace(_msg);
			--pendingdownload;
			checkifstilldownloading();
		}).onProgress(function(loaded, total)
		{
		}).onComplete(function (bytes:Bytes) {
			file.write(bytes);
			file.close();
			--pendingdownload;
			checkifstilldownloading();
		});
	}
	
	function checkifstilldownloading() {
		if (pendingdownload == 0) {
			process_downloads();
		}
	}
	
	function process_downloads() 
	{
		var downloads = FileSystem.readDirectory(env_path + "/downloads/");
		for (item in downloads) {
			if (item.indexOf(".zip", item.length - 4) != -1) {
				var zip = File.read(env_path + "/downloads/" + item);
				var entries = Reader.readZip(zip);
				var redist_path:String = "";
				for (entry in entries) {
					var path = env_path;
					if (entry.fileName.indexOf("/", entry.fileName.length - 1) != -1) {
						redist_path = entry.fileName;
					}
					else if (entry.fileName.indexOf(".wad") != -1 || entry.fileName.indexOf(".WAD") != -1) {
						if (FileSystem.exists(path + "/" + entry.fileName)) FileSystem.deleteFile(path + "/" + entry.fileName);
						var itemname = entry.fileName;
						itemname = itemname.substring(itemname.indexOf("/") + 1, itemname.length);
						var fileout = File.write(path + "/" + itemname);
						fileout.write(cust_unzip(entry));
						fileout.close();
					}
					else {
						path = env_path + "/redist/";
						if (!FileSystem.isDirectory(path + redist_path)) FileSystem.createDirectory(path + redist_path);
						if (FileSystem.exists(path + redist_path + entry.fileName)) FileSystem.deleteFile(path + redist_path + entry.fileName);
						var fileout = File.write(path + entry.fileName);
						fileout.write(cust_unzip(entry));
						fileout.close();
					}
				}
				zip.close();
			}
			FileSystem.deleteFile(env_path + "/downloads/" + item);
		}
		FileSystem.deleteDirectory(env_path + "/downloads");
		getwads();
	}
	
	function cust_unzip(f:Entry) {
		//Lime override's Haxe's normal reader function, this is just a copy and paste of it
		if (!f.compressed)
			return f.data;
		var c = new haxe.zip.Uncompress(-15);
		var s = haxe.io.Bytes.alloc(f.fileSize);
		var r = c.execute(f.data, 0, s, 0);
		c.close();
		if (!r.done || r.read != f.data.length || r.write != f.fileSize)
			throw "Invalid compressed data for " + f.fileName;
		f.compressed = false;
		f.dataSize = f.fileSize;
		f.data = s;
		return f.data;
	}
	
	#end
	
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
		
		Engine.LEVELS.loadMap("E1M1");
		
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