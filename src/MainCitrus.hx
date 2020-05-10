package;

import haxe.Http;
import haxe.Json;
import haxe.ui.components.Button;
import haxe.ui.components.DropDown;
import haxe.ui.components.HorizontalProgress;
import haxe.ui.components.Label;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.events.UIEvent;
import haxe.zip.Reader;
import haxe.zip.Uncompress;
import haxe.zip.Entry;
import lime.graphics.RenderContext;
import lime.ui.KeyModifier;
import lime.ui.MouseWheelMode;
import lime.ui.WindowAttributes;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;
import lime.net.HTTPRequest;
import citrus.render.limeGL.GLHandler;
import hxdoom.Engine;

import openfl.display.Stage;

import haxe.io.Bytes;
import lime.ui.KeyCode;


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

import haxe.ui.Toolkit;

class MainCitrus extends Application 
{
	var hxdoom:Engine;
	var entryway:Stage;
	var env_path:Null<String>;
	
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
		
		window.width = 640;
		window.height = 480;
		
		/*
		 * We're going to skip this for now until Lime updates.
		 * Lime currently has a bug with removing the OpenFL stage and is currently unreliable.
		 * This issue has been brought up and should come in the next update.
		 */
		//build_ui();
		
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
	
	var root_vbox:HBox = new HBox();
	var taskbox:VBox;
	var leftbox:VBox;
	var rightbox:VBox;
	var grabwads:Button;
	var iwad_selector:DropDown;
	var wadDataSource:ArrayDataSource<String> = new ArrayDataSource();
	var launch_button:Button;
	function build_ui() 
	{
		Toolkit.init();
		
		entryway = new Stage(this.window, 0xCCCCCC);
		addModule(entryway);
		
		entryway.addChild(root_vbox);
		root_vbox.x = root_vbox.y = 5;
		
		leftbox = new VBox();
		rightbox = new VBox();
		leftbox.width = rightbox.width = 200;
		root_vbox.addComponent(leftbox);
		root_vbox.addComponent(rightbox);
		
		taskbox = new VBox();
		rightbox.addComponent(taskbox);
		
		iwad_selector = new DropDown();
		leftbox.addComponent(iwad_selector);
		
		#if sys
		grabwads = new Button();
		grabwads.text = "Update Wad List";
		grabwads.onClick = function(e:UIEvent) {
			grabwads.disabled = true;
			download_wads();
		}
		leftbox.addComponent(grabwads);
		#end
		
		iwad_selector.disabled = true;
		iwad_selector.width = 150;
		
		launch_button = new Button();
		leftbox.addComponent(launch_button);
		launch_button.text = "Launch";
		launch_button.onClick = function(e:UIEvent) {
			#if sys
			var env = Sys.environment();
			var wad = File.getBytes(env["DOOMWADDIR"] + "/" + iwad_selector.value);
			launchGame(wad);
			#else
			//launchGame(Assets.getBytes("IWADS/DOOM1.WAD"));
			#end
		}
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
		
		wadDataSource = new ArrayDataSource();
		for (wad in pathlist.keys()) {
			wadDataSource.add(wad);
		}
		if (wadDataSource.size != 0) {
			iwad_selector.disabled = false;
			iwad_selector.selectedIndex = 0;
			iwad_selector.updateComponentDisplay();
		} else {
			wadDataSource.add("No IWADS found");
			iwad_selector.disabled = true;
		}
		iwad_selector.dataSource = wadDataSource;
		
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
			var warning:Label = new Label();
			warning.text = "Error! Unknown file, potentially corrupted!\n" + _name +"\n" + _msg;
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
		
		var label = new Label();
		var bar = new HorizontalProgress();
		label.value = _name;
		taskbox.addComponent(label);
		taskbox.addComponent(bar);
		
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
			bar.max = total;
			bar.value = loaded;
		}).onComplete(function (bytes:Bytes) {
			file.write(bytes);
			file.close();
			taskbox.removeComponent(bar);
			taskbox.removeComponent(label);
			--pendingdownload;
			checkifstilldownloading();
		});
	}
	
	function checkifstilldownloading() {
		if (pendingdownload == 0) {
			grabwads.disabled = false;
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
	
	var render_override:Bool = false;
	
	override public function render(context:RenderContext):Void 
	{
		
		if (hxdoom == null) return;
		
		if (!render_override) {
			//hook into Engine
			Engine.RENDER = new GLHandler(context, this.window);
			Engine.RENDER.initScene();
			render_override = true;
		}
		
		switch (context.type) {
			
			//Desktop, Android, and HTML5 with WebGL support
			case OPENGL, OPENGLES, WEBGL:
				
				if (Engine.ACTIVEMAP != null) Engine.RENDER.setVisibleSegments();
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
		//entryway.removeChild(root_vbox);
		//removeModule(entryway);
		//entryway = null;
		hxdoom = new Engine();
		hxdoom.addWad(_wadbytes, "DOOM1.WAD");
		hxdoom.loadMap("E1M1");
	}
	
	override public function onWindowResize(width:Int, height:Int):Void 
	{
		super.onWindowResize(width, height);
		
		if (Engine.RENDER != null) Engine.RENDER.resize(width, height);
	}
	
	override public function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		Engine.IO.keyRelease(keyCode);
	}
	
	override public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		Engine.IO.keyPress(keyCode);
	}
	
	/*override public function onMouseWheel(deltaX:Float, deltaY:Float, deltaMode:MouseWheelMode):Void 
	{
		super.onMouseWheel(deltaX, deltaY, deltaMode);
		
		var mxa:Float = 
		Environment.AUTOMAP_ZOOM += (0.0001 * deltaY) / (1 / Environment.AUTOMAP_ZOOM / 200);
	}*/
	
	public static function getWadDir() {
		
	}
}