package packages.wad;

import display.ActorSprite;
import packages.wad.maplumps.LineDef;
import packages.wad.maplumps.Node;
import packages.wad.maplumps.Segment;
import packages.wad.maplumps.SubSector;
import packages.wad.maplumps.Thing;
import packages.wad.maplumps.Vertex;

/**
 * ...
 * @author Kaelan
 */
class Map 
{
	public var name:String;
	public var things:Array<Thing>;
	public var actorsprites:Array<ActorSprite>;
	public var vertexes:Array<Vertex>;
	public var linedefs:Array<LineDef>;
	public var nodes:Array<Node>;
	public var subsectors:Array<SubSector>;
	public var segments:Array<Segment>;
	
	public var offset_x:Float;
	public var offset_y:Float;
	
	public var dirOffset:Int;
	public var hasBeenBuilt:Bool;
	public function new(_dirOffset:Int) 
	{
		dirOffset = _dirOffset;
		hasBeenBuilt = false;
		
		things = new Array();
		vertexes = new Array();
		linedefs = new Array();
		nodes = new Array();
		subsectors = new Array();
		segments = new Array();
		actorsprites = new Array();
	}
	
	public function setOffset() {
		var mapx = Math.POSITIVE_INFINITY;
		var mapy = Math.POSITIVE_INFINITY;
		for (a in vertexes) {
			if (a.xpos < mapx) mapx = a.xpos;
			if (a.ypos < mapy) mapy = a.ypos;
		}
			
		offset_x = mapx * -1;
		offset_y = mapy * -1;
	}
	
}

/*
typedef Map = {
	var name:String;
	var player:Array<Player>;
	var vertexes:Array<Vertex>;
	var linedefs:Array<LineDef>;
	var nodes:Array<Node>;
	var subsectors:Array<Subsector>;
	var seg:Array<Seg>;
	var things:Array<Thing>;
	var offset_x:Float;
	var offset_y:Float;
}
*/