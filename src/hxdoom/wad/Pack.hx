package hxdoom.wad;

import haxe.ds.Map;
import haxe.PosInfos;
import haxe.io.Bytes;
import hxdoom.wad.graphiclumps.Playpal;
import hxdoom.wad.maplumps.LineDef;
import hxdoom.wad.maplumps.Segment;
import hxdoom.wad.maplumps.Vertex;
import hxdoom.wad.maplumps.Thing;

import hxdoom.com.Environment;

import hxdoom.wad.Directory;
import hxdoom.wad.BSPMap;

/**
 * ...
 * @author Kaelan
 * 
 * To reduce typing redundancy, I named this class "pack" to represent the wad data as a whole.
 */
class Pack 
{
	//public static var SPRITELIST:Map<String, some class here> = new Map(); 
	var data:Array<Int>;
	var wadname:String;
	var isIwad:Bool;
	
	var directories:Array<Directory>;
	var directory_count:Int;
	var directory_offset:Int;
	
	var playpal:Playpal
	
	public var maps:Array<BSPMap>;
	/**
	 * Currently loaded map
	 */
	public var activeMap:BSPMap;
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
		
		getDirectoryListing();
		indexMaps();
	}
	function getDirectoryListing() {
		directory_count = Reader.getFourBytes(data, 0x04);
		directory_offset = Reader.getFourBytes(data, 0x08);
		
		directories = new Array();
		for (a in 0...directory_count) {
			directories[a] = Reader.readDirectory(data, directory_offset + a * 16);
			//trace(directories[a], a);
		}
	}
	function indexMaps() 
	{
		maps = new Array();
		for (dir in 0...directories.length) {
			switch (directories[dir].name) {
				case (Lump.BLOCKMAP) :
					if (dir < 10) continue;
					if (directories[dir - 9].name 	 == 	Lump.THINGS	
						&& directories[dir - 8].name == 	Lump.LINEDEFS
						&& directories[dir - 7].name == 	Lump.SIDEDEFS
						&& directories[dir - 6].name == 	Lump.VERTEXES
						&& directories[dir - 5].name == 	Lump.SEGS
						&& directories[dir - 4].name == 	Lump.SSECTORS
						&& directories[dir - 3].name == 	Lump.NODES
						&& directories[dir - 2].name == 	Lump.SECTORS
						&& directories[dir - 1].name == 	Lump.REJECT
						&& directories[dir].name 	 == 	Lump.BLOCKMAP
					) {
						maps.push(new BSPMap(dir));
						loadMap(maps.length - 1);
					}
				case (Lump.PLAYPAL) :
					loadPlaypal();
					trace (directories[dir].size);
				default :
					trace (directories[dir].name);
			}
		}
	}
	/**
	 * Loads in and sets 'activeMap' the specified map
	 * @param	_index map index
	 */
	public function loadMap(_index:Int, ?_pos:PosInfos) {
		if (maps[_index] == null) Environment.GlobalThrowError("This map does not exist! This is supposed to be a debug throw and never to be seen under normal conditions, please report a new issue and include this information!\n\n" + _pos);
		//Should be impossible for a case where a null item is supposed to contain a map
		//extensive testing is necesary. Leaving in just in case while this function is
		//unknown to be stable or not
		
		var place:Int = 0;
		var numitems:Int = 0;
		
		var _map = maps[_index];
		var _offset = _map.dirOffset;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load nodes
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 3].size / Reader.NODE_LUMP_SIZE);
		place = directories[_offset - 3].offset;
		for (a in 0...numitems) {
			_map.nodes[a] = Reader.readNode(data, place + a * Reader.NODE_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load vertexes
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 6].size / Reader.VERTEX_LUMP_SIZE);
		place = directories[_offset - 6].offset;
		for (a in 0...numitems) {
			_map.vertexes[a] = Reader.readVertex(data, place + a * Reader.VERTEX_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load Subsectors
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 4].size / Reader.SSECTOR_LUMP_SIZE);
		place = directories[_offset - 4].offset;
		for (a in 0...numitems) {
			_map.subsectors[a] = Reader.readSubSector(data, place + a * Reader.SSECTOR_LUMP_SIZE, _map.segments);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load things
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 9].size / Reader.THING_LUMP_SIZE);
		place = directories[_offset - 9].offset;
		for (a in 0...numitems) {
			_map.things[a] = Reader.readThing(data, place + a * Reader.THING_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load sectors
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 2].size / Reader.SECTOR_LUMP_SIZE);
		place = directories[_offset - 2].offset;
		for (a in 0...numitems) {
			_map.sectors[a] = Reader.readSector(data, place + a * Reader.SECTOR_LUMP_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load sidedefs
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 7].size / Reader.SIDEDEF_LUMP_SIZE);
		place = directories[_offset - 7].offset;
		for (a in 0...numitems) {
			_map.sidedefs[a] = Reader.readSideDef(data, place + a * Reader.SIDEDEF_LUMP_SIZE, _map.sectors);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load linedefs
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 8].size / Reader.LINEDEF_LUMP_SIZE);
		place = directories[_offset - 8].offset;
		for (a in 0...numitems) {
			_map.linedefs[a] = Reader.readLinedef(data, place + a * Reader.LINEDEF_LUMP_SIZE, _map.vertexes, _map.sidedefs);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load segments
		////////////////////////////////////////////////////////////////////////////////////////////////////
		numitems = Std.int(directories[_offset - 5].size / Reader.SEG_LUMP_SIZE);
		place = directories[_offset - 5].offset;
		for (a in 0...numitems) {
			_map.segments[a] = Reader.readSegment(data, place + a * Reader.SEG_LUMP_SIZE, _map.linedefs);
		}
		
		//Map name as stated in WAD, IE E#M#/MAP##
		_map.name = directories[_offset - 10].name;
		
		Engine.ACTIVEMAP = _map;
		Engine.ACTIVEMAP.parseThings();
		Engine.ACTIVEMAP.setOffset();
	}
	
	public function loadPlaypal() {
		
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