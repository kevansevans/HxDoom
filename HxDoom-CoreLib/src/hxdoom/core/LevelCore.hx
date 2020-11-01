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
	
	public var expectedLumpsPerMap:Int = 9; //set this to 10 when blockmap and reject are supported, 11 for hexen
	
	public function loadMap(_mapMarker:String):Bool {
		
		if (!Engine.WADDATA.wadContains([_mapMarker])) {
			return false;
		}
		
		var loaded_lumps:Int = 0;
		var iterated_lumps:Int = 0;
		
		var place:Int = 0;
		var numitems:Int = 0;
		
		var _map = LevelMap.CONSTRUCTOR();
		
		var mapmarker:Directory = Engine.WADDATA.getDirectory(_mapMarker);
		var byteData = Engine.WADDATA.getWadByteArray(mapmarker.wad);
		
		var lumpOffset:Int = 1;
		while (true) {
			
			var mapDir = Engine.WADDATA.getIndexSpecificDir(mapmarker.wad, mapmarker.index + lumpOffset);
			
			if  (mapDir.size == 0) {
				break;
			}
			
			++iterated_lumps;
			
			if (iterated_lumps > expectedLumpsPerMap) {
				Engine.log(['Iterated lumps (' + iterated_lumps + ') greater than expected lumps (' + expectedLumpsPerMap + '), please investigate']);
			}
			
			switch (mapDir.name) {
				case KeyLump.THINGS :
					numitems = Std.int(mapDir.size / Thing.BYTE_SIZE);
					for (a in 0...numitems) {
						_map.things[a] = Reader.readThing(byteData, mapDir.dataOffset + a * Thing.BYTE_SIZE);
					}
					++loaded_lumps;
				case KeyLump.LINEDEFS :
					numitems = Std.int(mapDir.size / LineDef.BYTE_SIZE);
					for (a in 0...numitems) {
						_map.linedefs[a] = Reader.readLinedef(byteData, mapDir.dataOffset + a * LineDef.BYTE_SIZE);
						_map.linedefs[a].lineID = a;
					}
					++loaded_lumps;
				case KeyLump.SIDEDEFS :
					numitems = Std.int(mapDir.size / SideDef.BYTE_SIZE);
					for (a in 0...numitems) {
						_map.sidedefs[a] = Reader.readSideDef(byteData, mapDir.dataOffset + a * SideDef.BYTE_SIZE);
					}
					++loaded_lumps;
				case KeyLump.VERTEXES :
					numitems = Std.int(mapDir.size / Vertex.BYTE_SIZE);
					for (a in 0...numitems) {
						_map.vertexes[a] = Reader.readVertex(byteData, mapDir.dataOffset + a * Vertex.BYTE_SIZE);
					}
					++loaded_lumps;
				case KeyLump.SEGS :
					numitems = Std.int(mapDir.size / Segment.BYTE_SIZE);
					for (a in 0...numitems) {
						_map.segments[a] = Reader.readSegment(byteData, mapDir.dataOffset + a * Segment.BYTE_SIZE);
					}
					++loaded_lumps;
				case KeyLump.SSECTORS :
					numitems = Std.int(mapDir.size / SubSector.BYTE_SIZE);
					for (a in 0...numitems) {
						_map.subsectors[a] = Reader.readSubSector(byteData, mapDir.dataOffset + a * SubSector.BYTE_SIZE);
					}
					++loaded_lumps;
				case KeyLump.NODES :
					numitems = Std.int(mapDir.size / Node.BYTE_SIZE);
					for (a in 0...numitems) {
						_map.nodes[a] = Reader.readNode(byteData, mapDir.dataOffset + a * Node.BYTE_SIZE);
					}
					++loaded_lumps;
				case KeyLump.SECTORS :
					numitems = Std.int(mapDir.size / Sector.BYTE_SIZE);
					for (a in 0...numitems) {
						_map.sectors[a] = Reader.readSector(byteData, mapDir.dataOffset + a * Sector.BYTE_SIZE);
					}
					++loaded_lumps;
				case KeyLump.BLOCKMAP :
					_map.blockmap = Reader.readBlockmap(byteData, mapDir.dataOffset);
					++loaded_lumps;
				default :
					Engine.log(["Map directory unrecognized: " + mapDir.name]);
			}
			
			lumpOffset += 1;
		}
		
		_map.name = Engine.WADDATA.getWadSpecificDir(mapmarker.wad, mapmarker.name).name;
		
		currentMap = _map;
		currentMap.build();
		
		needToRebuild = true;
		
		return true;
	}
}