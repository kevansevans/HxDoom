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
import hxdoom.wad.maplumps.Segment;
import hxdoom.wad.maplumps.Vertex;

import hxdoom.actors.TypeID;
import hxdoom.wad.Pack;
import hxdoom.wad.LevelID;

import hxdoom.Engine;
import hxdoom.com.Environment;

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
	var draw:Sprite;
	var mapsprite:Sprite;
	var subSectorsprite:Sprite;
	var thingprite:Sprite;
	
	var infotext:TextField;
	
	var hxdoom:Engine;
	
	public function new() 
	{
		super();
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Start engine here
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		hxdoom = new Engine();
		
		//we're going to assume a IWAD picker has been made
		#if sys
		hxdoom.setBaseIwad(File.getBytes("./IWAD/DOOM1.WAD"), "DOOM1.WAD");
		#elseif js
		
		#end
		
		return;
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
