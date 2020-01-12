package hxdoom.data;

import hxdoom.actors.Player;
import hxdoom.actors.TypeID;
import hxdoom.data.maplumps.LineDef;
import hxdoom.data.maplumps.Node;
import hxdoom.data.maplumps.Sector;
import hxdoom.data.maplumps.Segment;
import hxdoom.data.maplumps.SideDef;
import hxdoom.data.maplumps.SubSector;
import hxdoom.data.maplumps.Thing;
import hxdoom.data.maplumps.Vertex;
import packages.actors.*;
import packages.wad.maplumps.*;
import hxdoom.com.Environment;
import hxdoom.abstracts.Angle;
/**
 * ...
 * @author Kaelan
 */
class BSPMap 
{
	public var name:String;
	
	public var things:Array<Thing>;
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
	
	public var actors_players:Array<Player>;
	
	public function new(_dirOffset:Int) 
	{
		dirOffset = _dirOffset;
		
		things = new Array();
		vertexes = new Array();
		linedefs = new Array();
		nodes = new Array();
		subsectors = new Array();
		segments = new Array();
		sidedefs = new Array();
		sectors = new Array();
	}
	
	public function parseThings() {
		actors_players = new Array();
		for (thing in things) {
			switch (thing.type) {
				case TypeID.P_PLAYERONE | TypeID.P_PLAYERTWO | TypeID.P_PLAYERTHREE | TypeID.P_PLAYERFOUR:
					actors_players.push(new Player(thing));
			}
		}
	}
	
	public function getVisibleSegments():Array<Segment> {
		var visible:Array<Segment> = new Array();
		var player = actors_players[0];
		
		for (segment in segments) {
			var startAngle:Angle = player.angleToVertex(segment.start) - player.angle;
			var endAngle:Angle = player.angleToVertex(segment.end) - player.angle;
			
			var span:Angle = startAngle - endAngle;
			if (span >= 180) continue;
			
			var startAngleLeftFov:Angle = startAngle + (Environment.PLAYER_FOV / 2);
			
			if (startAngleLeftFov > Environment.PLAYER_FOV) {
				var startAngleMoved:Angle = startAngleLeftFov - Environment.PLAYER_FOV;
				
				if (startAngleMoved > span) continue;
				startAngle = (Environment.PLAYER_FOV / 2);
			}
			
			visible.push(segment);
			segment.hasBeenSeen = true;
		}
		
		return visible;
	}
	
	public function setOffset() {
		var mapx = Math.POSITIVE_INFINITY;
		var mapy = Math.POSITIVE_INFINITY;
		for (a in vertexes) {
			if (a.xpos < mapx) mapx = a.xpos;
			if (a.ypos < mapy) mapy = a.ypos;
		}
			
		offset_x = mapx - (actors_players[0].xpos + mapx);
		offset_y = mapy - (actors_players[0].ypos + mapy);
	}
	
}