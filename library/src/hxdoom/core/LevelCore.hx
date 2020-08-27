package hxdoom.core;

import hxdoom.Engine;
import hxdoom.lumps.Directory;
import hxdoom.component.LevelMap;
import hxdoom.definitions.EpisodeDef;
import hxdoom.definitions.MapDef;
import hxdoom.lumps.map.*;
import hxdoom.enums.eng.KeyLump;

/**
 * ...
 * @author Kaelan
 */
class LevelCore 
{
	public var levelData:Array<MapDef>;
	public var episodeData:Array<EpisodeDef>;
	public var currentMap:LevelMap;
	public var currentMapData:MapDef;
	public var currentEpisodeData:EpisodeDef;
	
	public var needToRebuild:Bool = true;
	
	public function new() 
	{
		
	}
	
	public function startEpisode(_index:Int) {
		if (episodeData == null) {
			trace("Episode data undefined!");
			return;
		}
		startMap(episodeData[_index].firstLevel);
	}
	
	public function startMap(_index:Int) {
		if (levelData == null) {
			trace("Level data undefined!");
			return;
		}
		loadMap(levelData[_index].internalName);
		currentMapData = levelData[_index];
	}
	public function exitMapNormal() {
		if (levelData == null) {
			trace("Level data undefined!");
			return;
		}
		currentMapData = levelData[currentMapData.nextMap];
		loadMap(currentMapData.internalName);
	}
	public function exitMapSecret() {
		if (levelData == null) {
			trace("Level data undefined!");
			return;
		}
		currentMapData = levelData[currentMapData.nextMapSecret];
		loadMap(currentMapData.internalName);
	}
	
	
	public function loadMap(_mapMarker:String):Bool {
		
		if (!Engine.WADDATA.wadContains([_mapMarker])) {
			return false;
		}
		
		var place:Int = 0;
		var numitems:Int = 0;
		
		var _map = new LevelMap();
		var mapmarker:Directory = Engine.WADDATA.getGeneralDir(_mapMarker);
		var byteData = Engine.WADDATA.getWadByteArray(mapmarker.wad);
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load things
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 1).name != KeyLump.THINGS) {
			Engine.log("Map data corrupt: Expected Things, found: " + Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 1).name);
			return false;
		}
		numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 1).size / Thing.BYTE_SIZE);
		place = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 1).dataOffset;
		for (a in 0...numitems) {
			_map.things[a] = Reader.readThing(byteData, place + a * Thing.BYTE_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load linedefs
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 2).name != KeyLump.LINEDEFS) {
			Engine.log("Map data corrupt: Expected Linedefss, found: " + Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 2).name);
			return false;
		}
		numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 2).size / LineDef.BYTE_SIZE);
		place = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 2).dataOffset;
		for (a in 0...numitems) {
			_map.linedefs[a] = Reader.readLinedef(byteData, place + a * LineDef.BYTE_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load sidedefs
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 3).name != KeyLump.SIDEDEFS) {
			Engine.log("Map data corrupt: Expected Sidedefs, found: " + Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 3).name);
			return false;
		}
		numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 3).size / SideDef.BYTE_SIZE);
		place = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 3).dataOffset;
		for (a in 0...numitems) {
			_map.sidedefs[a] = Reader.readSideDef(byteData, place + a * SideDef.BYTE_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load vertexes
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 4).name != KeyLump.VERTEXES) {
			Engine.log("Map data corrupt: Expected Vertexes, found: " + Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 4).name);
			return false;
		}
		numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 4).size / Vertex.BYTE_SIZE);
		place = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 4).dataOffset;
		for (a in 0...numitems) {
			_map.vertexes[a] = Reader.readVertex(byteData, place + a * Vertex.BYTE_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load segments
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 5).name != KeyLump.SEGS) {
			Engine.log("Map data corrupt: Expected Segments, found: " + Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 5).name);
			return false;
		}
		numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 5).size / Segment.BYTE_SIZE);
		place = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 5).dataOffset;
		for (a in 0...numitems) {
			_map.segments[a] = Reader.readSegment(byteData, place + a * Segment.BYTE_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load Subsectors
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 6).name != KeyLump.SSECTORS) {
			Engine.log("Map data corrupt: Expected Subsectors, found: " + Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 6).name);
			return false;
		}
		numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 6).size / SubSector.BYTE_SIZE);
		place = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 6).dataOffset;
		for (a in 0...numitems) {
			_map.subsectors[a] = Reader.readSubSector(byteData, place + a * SubSector.BYTE_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load nodes
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 7).name != KeyLump.NODES) {
			Engine.log("Map data corrupt: Expected Nodes, found: " + Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 7).name);
			return false;
		}
		numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 7).size / Node.BYTE_SIZE);
		place = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 7).dataOffset;
		for (a in 0...numitems) {
			_map.nodes[a] = Reader.readNode(byteData, place + a * Node.BYTE_SIZE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Load sectors
		////////////////////////////////////////////////////////////////////////////////////////////////////
		if (Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 8).name != KeyLump.SECTORS) {
			Engine.log("Map data corrupt: Expected Sectors, found: " + Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 8).name);
			return false;
		}
		numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 8).size / Sector.BYTE_SIZE);
		place = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + 8).dataOffset;
		for (a in 0...numitems) {
			_map.sectors[a] = Reader.readSector(byteData, place + a * Sector.BYTE_SIZE);
		}
		
		//Map name as stated in WAD, IE E#M#/MAP##
		_map.name = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index).name;
		
		currentMap = _map;
		currentMap.parseThings();
		currentMap.setOffset();
		currentMap.build();
		
		needToRebuild = true;
		
		return true;
	}
}