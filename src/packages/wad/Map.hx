package packages.wad;

import display.ActorSprite;
import packages.actors.*;
import packages.wad.maplumps.*;
import global.Common;
/**
 * ...
 * @author Kaelan
 */
class Map 
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
	
	public var actorsprites:Array<ActorSprite>;
	
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
		actorsprites = new Array();
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
			var startAngle:Float = player.angleToVertex(segment.start) - player.angle;
			var endAngle:Float = player.angleToVertex(segment.end) - player.angle;
			
			if (startAngle < 0) startAngle += 360;
			if (startAngle > 360) startAngle -= 360;
			
			if (endAngle < 0) endAngle += 360;
			if (endAngle > 360) endAngle -= 360;
			
			var span = startAngle - endAngle;
			if (span < 0) span += 360;
			if (span > 360) span -= 360;
			
			var startAngleLeftFov = startAngle + (Common.PLAYER_FOV / 2);
			if (startAngleLeftFov > Common.PLAYER_FOV) {
				var startAngleMoved = startAngleLeftFov - Common.PLAYER_FOV;
				if (startAngleMoved > span) continue;
				startAngle = (Common.PLAYER_FOV / 2);
			}
			
			var endAngleRightFov = endAngle - (Common.PLAYER_FOV / 2);
			if (endAngleRightFov > Common.PLAYER_FOV) {
				
				endAngle = -(Common.PLAYER_FOV / 2);
			}
			
			if (span >= 180) continue;
			
			visible.push(segment);
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
			
		offset_x = mapx * -1;
		offset_y = mapy * -1;
	}
	
}