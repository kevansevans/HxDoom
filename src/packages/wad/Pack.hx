package packages.wad;

import display.ActorSprite;
import haxe.PosInfos;
import haxe.io.Bytes;
import packages.wad.maplumps.LineDef;
import packages.wad.maplumps.Segment;
import packages.wad.maplumps.Vertex;
import packages.wad.maplumps.Thing;

import global.Common;

import packages.wad.Directory;
import packages.wad.Map;

/**
 * ...
 * @author Kaelan
 * 
 * To reduce typing redundancy, I named this class "pack" to represent the wad data as a whole.
 */
class Pack 
{
	var reader:Reader;
	var data:Array<Int>;
	var wadname:String;
	var isIwad:Bool;
	
	var directories:Array<Directory>;
	var directory_count:Int;
	var directory_offset:Int;
	
	var maps:Array<Map>;
	/**
	 * Currently loaded map
	 */
	public var activeMap:Map;
	/**
	 * Getter to retrieve active map's vertexes
	 */
	public var vertexes(get, null):Array<Vertex>;
	/**
	 * Getter to retrieve active map's linedefs
	 */
	public var linedefs(get, null):Array<LineDef>;
	/**
	 * Getter to retrieve active map's things
	 */
	public var things(get, null):Array<Thing>;
	/**
	 * Getter to retrieve segments
	 */
	public var segments(get, null):Array<Segment>;
	
	/**
	 * Constructor for new WAD
	 * 
	 * @param	_data Haxe.io.bytes, gets converted into int Array for JS friendliness
	 * @param	_name String denoting file name to prevent overlapping
	 * @param	_iwad Is this wad an IWAD?
	 */
	public function new(_data:Bytes, _name:String, _iwad:Bool = false) 
	{
		data = new Array();
		for (a in 0..._data.length) {
			data.push(_data.get(a));
		}
		
		wadname = _name;
		
		isIwad = _iwad;
		
		reader = new Reader();
		
		getDirectoryListing();
		indexMaps();
	}
	function getDirectoryListing() {
		directory_count = reader.getFourBytes(data, 0x04);
		directory_offset = reader.getFourBytes(data, 0x08);
		
		directories = new Array();
		for (a in 0...directory_count) {
			directories[a] = reader.readDirectory(data, directory_offset + a * 16);
			//trace(directories[a], a);
		}
	}
	function indexMaps() 
	{
		maps = new Array();
		for (dir in 0...directories.length) {
			if (dir < 10) continue;
			if (	directories[dir - 9].name == 		"THINGS" 	// Actors, positions and what they are
					&& directories[dir - 8].name == 	"LINEDEFS"	// lines, describing behavior between two points
					&& directories[dir - 7].name == 	"SIDEDEFS"	// Describes which linedefs posses what textures
					&& directories[dir - 6].name == 	"VERTEXES"	// Each XY position of lines
					&& directories[dir - 5].name == 	"SEGS"		//
					&& directories[dir - 4].name == 	"SSECTORS"	//
					&& directories[dir - 3].name == 	"NODES"		//
					&& directories[dir - 2].name == 	"SECTORS"	// Closed linedefs
					&& directories[dir - 1].name == 	"REJECT"	//
					&& directories[dir].name == 		"BLOCKMAP"	//
				) {
					maps.push(new Map(dir));
				}
		}
	}
	/**
	 * Loads in and sets 'activeMap' the specified map
	 * @param	_index map index
	 */
	public function loadMap(_index:Int, ?_pos:PosInfos) {
		if (maps[_index] == null) Common.GlobalThrowError("This map does not exist! This is supposed to be a debug throw and never to be seen under normal conditions, please report a new issue and include this information!\n\n" + _pos);
		//Should be impossible for a case where a null item is supposed to contain a map
		//extensive testing is necesary. Leaving in just in case while this function is
		//unknown to be stable or not
		
		var place:Int = 0;
		var numitems:Int = 0;
		
		var _map = maps[_index];
		var _offset = _map.dirOffset;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load vertexes
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 6].size / Reader.VERTEX_LUMP_SIZE);
		place = directories[_offset - 6].offset;
		for (a in 0...numitems) {
			_map.vertexes[a] = reader.readVertex(data, place + a * Reader.VERTEX_LUMP_SIZE);
		}
		_map.setOffset();
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load linedefs
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 8].size / Reader.LINEDEF_LUMP_SIZE);
		place = directories[_offset - 8].offset;
		for (a in 0...numitems) {
			_map.linedefs[a] = reader.readLinedef(data, place + a * Reader.LINEDEF_LUMP_SIZE, _map.vertexes);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load segments
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 5].size / Reader.SEG_LUMP_SIZE);
		place = directories[_offset - 5].offset;
		for (a in 0...numitems) {
			_map.segments[a] = reader.readSegment(data, place + a * Reader.SEG_LUMP_SIZE, _map.linedefs);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load Subsectors
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 4].size / Reader.SSECTOR_LUMP_SIZE);
		place = directories[_offset - 4].offset;
		for (a in 0...numitems) {
			_map.subsectors[a] = reader.readSubSector(data, place + a * Reader.SSECTOR_LUMP_SIZE, _map.segments);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load things
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 9].size / Reader.THING_LUMP_SIZE);
		place = directories[_offset - 9].offset;
		for (a in 0...numitems) {
			_map.things[a] = reader.readThing(data, place + a * Reader.THING_LUMP_SIZE);
			_map.actorsprites[a] = new ActorSprite(32, _map.things[a].type, _map.things[a].angle);
		}
		
		//Map name as stated in WAD, IE E#M#/MAP##
		_map.name = directories[_offset - 10].name;
		
		activeMap = _map;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//Getters
	////////////////////////////////////////////////////////////////////////////////////////////////////
	function get_vertexes():Array<Vertex> 
	{
		return activeMap.vertexes;
	}
	
	function get_linedefs():Array<LineDef> 
	{
		return activeMap.linedefs;
	}
	
	function get_things():Array<Thing> 
	{
		return activeMap.things;
	}
	
	function get_segments():Array<Segment> 
	{
		return activeMap.segments;
	}
	
	/*
	 * Some node traversal functions
	 * public function isPointOnBackSide(_x:Int, _y:Int, _nodeID:Int):Bool
	{
		var dx = _x - activemap.nodes[_nodeID].xPartition;
		var dy = _y - activemap.nodes[_nodeID].yPartition;
		
		return (((dx *  activemap.nodes[_nodeID].changeYPartition) - (dy * activemap.nodes[_nodeID].changeXPartition)) <= 0);
	}
	
	public function getPlayerNode():Node {
		var node:Int = activemap.nodes.length - 1;
		while (true) {
			if (activemap.nodes[node].backChildID & SUBSECTORIDENTIFIER > 0 || activemap.nodes[node].frontChildID & SUBSECTORIDENTIFIER > 0 ) {
				return activemap.nodes[node];
			}
			var isOnBack:Bool = isPointOnBackSide(activemap.things[0].xpos, activemap.things[0].ypos, node);
			if (isOnBack) {
				node = activemap.nodes[node].backChildID;
			} else {
				node = activemap.nodes[node].frontChildID;
			}
		}
	}
	 */
}