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
		
		var lumpOffset:Int = 1;
		var reg:EReg = new EReg("(E[0-9]+M[0-9]+)|(MAP[0-9]+)", "i");
		while (true) {
			
			var mapDir = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index + lumpOffset);
			
			//this could probably be replaced with a size check, iirc map markers posses 0 offset and 0 size. Please test this.
			if  (reg.match(mapDir.name)) break;
			
			switch (mapDir.name) {
				case KeyLump.THINGS :
					numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).size / Thing.BYTE_SIZE);
					place = Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).dataOffset;
					for (a in 0...numitems) {
						_map.things[a] = Reader.readThing(byteData, place + a * Thing.BYTE_SIZE);
					}
				case KeyLump.LINEDEFS :
					numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).size / LineDef.BYTE_SIZE);
					place = Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).dataOffset;
					for (a in 0...numitems) {
						_map.linedefs[a] = Reader.readLinedef(byteData, place + a * LineDef.BYTE_SIZE);
					}
				case KeyLump.SIDEDEFS :
					numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).size / SideDef.BYTE_SIZE);
					place = Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).dataOffset;
					for (a in 0...numitems) {
						_map.sidedefs[a] = Reader.readSideDef(byteData, place + a * SideDef.BYTE_SIZE);
					}
				case KeyLump.VERTEXES :
					numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).size / Vertex.BYTE_SIZE);
					place = Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).dataOffset;
					for (a in 0...numitems) {
						_map.vertexes[a] = Reader.readVertex(byteData, place + a * Vertex.BYTE_SIZE);
					}
				case KeyLump.SEGS :
					numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).size / Segment.BYTE_SIZE);
					place = Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).dataOffset;
					for (a in 0...numitems) {
						_map.segments[a] = Reader.readSegment(byteData, place + a * Segment.BYTE_SIZE);
					}
				case KeyLump.SSECTORS :
					numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).size / SubSector.BYTE_SIZE);
					place = Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).dataOffset;
					for (a in 0...numitems) {
						_map.subsectors[a] = Reader.readSubSector(byteData, place + a * SubSector.BYTE_SIZE);
					}
				case KeyLump.NODES :
					numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).size / Node.BYTE_SIZE);
					place = Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).dataOffset;
					for (a in 0...numitems) {
						_map.nodes[a] = Reader.readNode(byteData, place + a * Node.BYTE_SIZE);
					}
				case KeyLump.SECTORS :
					numitems = Std.int(Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).size / Sector.BYTE_SIZE);
					place = Engine.WADDATA.getWadSpecificDir(mapDir.wad, mapDir.index).dataOffset;
					for (a in 0...numitems) {
						_map.sectors[a] = Reader.readSector(byteData, place + a * Sector.BYTE_SIZE);
					}
				default :
					Engine.log("Map directory unrecognized: " + mapDir.name);
			}
			
			lumpOffset += 1;
		}
		
		_map.name = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.index).name;
		
		currentMap = _map;
		currentMap.parseThings();
		currentMap.setOffset();
		currentMap.build();
		
		needToRebuild = true;
		
		return true;
	}
}