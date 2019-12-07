package packages.wad;

import display.ActorSprite;
import packages.wad.maplumps.LineDef;
import packages.wad.maplumps.Node;
import packages.wad.maplumps.Sector;
import packages.wad.maplumps.Segment;
import packages.wad.maplumps.SideDef;
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
	public var sidedefs:Array<SideDef>;
	public var sectors:Array<Sector>;
	
	public var offset_x:Float;
	public var offset_y:Float;
	
	public var dirOffset:Int;
	public function new(_dirOffset:Int) 
	{
		dirOffset = _dirOffset;
		
		things = new Array();
		vertexes = new Array();
		linedefs = new Array();
		nodes = new Array();
		subsectors = new Array();
		segments = new Array();
		actorsprites = new Array();
		sidedefs = new Array();
		sectors = new Array();
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