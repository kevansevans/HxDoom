package hxdoom.core;

import haxe.ds.Vector;
import hxdoom.actors.Player;
import hxdoom.actors.TypeID;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Node;
import hxdoom.lumps.map.Sector;
import hxdoom.lumps.map.Segment;
import hxdoom.lumps.map.SideDef;
import hxdoom.lumps.map.SubSector;
import hxdoom.lumps.map.Thing;
import hxdoom.lumps.map.Vertex;
import packages.actors.*;
import packages.wad.maplumps.*;
import hxdoom.common.Environment;
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
	
	var node_visited:Array<Bool>;
	
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
		
		node_visited = new Array();
		node_visited.resize(nodes.length);
		for (n in 0...nodes.length) {
			node_visited[n] = false;
		}
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
	
	var hwidth:Int = 320;
	var hor_walldraw:Array<Null<Bool>> = new Array();
	var scanning = false;
	
	
	public function setVisibleSegments() {
		scanning = true;
		for (x in 0...(hwidth + 1)) {
			hor_walldraw[x] = false;
		}
		for (seg in segments) {
			seg.visible = false;
		}
		for (n in 0...node_visited.length) {
			node_visited[n] = false;
		}
		recursiveNodeTraversalVisibility(nodes.length -1);
	}
	function recursiveNodeTraversalVisibility(_nodeIndex:Int) {
		
		if (!scanning) return;
		
		node_visited[_nodeIndex] = true;
		
		var node = nodes[_nodeIndex];
		
		var fronsubsec:Bool = false;
		var backsubsec:Bool = false;
		
		//Check if we've gone down both nodes
		if (node_visited[node.frontChildID] && node_visited[node.backChildID]) {
			if (node.parent == -1) {
				return;
			}
			recursiveNodeTraversalVisibility(node.parent);
			return;
		} 
		if (node_visited[node.frontChildID]) {
			fronsubsec = true;
		} 
		if (node_visited[node.backChildID]) {
			backsubsec = true;
		}
		
		//which children are subsectors?
		if (node.frontChildID & Node.SUBSECTORIDENTIFIER > 0) {
			fronsubsec = true;
			subsectorVisibilityCheck(node.frontChildID & (~Node.SUBSECTORIDENTIFIER));
		}
		if (node.backChildID & Node.SUBSECTORIDENTIFIER > 0) {
			backsubsec = true;
			subsectorVisibilityCheck(node.backChildID & (~Node.SUBSECTORIDENTIFIER));
		}
		//Do we need to keep searching down the tree?
		if (fronsubsec && backsubsec) {
			recursiveNodeTraversalVisibility(node.parent);
			return;
		}
		if (fronsubsec && !backsubsec) {
			recursiveNodeTraversalVisibility(node.backChildID);
			return;
		} else if (!fronsubsec && backsubsec) {
			recursiveNodeTraversalVisibility(node.frontChildID);
			return;
		}
		
		//neither have been visited, neither are subsectors, so which one is closer?
		var isOnBack:Bool = isPointOnBackSide(actors_players[0].xpos, actors_players[0].ypos, _nodeIndex);
		if (isOnBack) {
			recursiveNodeTraversalVisibility(node.backChildID);
		} else {
			recursiveNodeTraversalVisibility(node.frontChildID);
		}
	}
	
	function subsectorVisibilityCheck(_subsector:Int) {
		
		var player = actors_players[0];
		var subsector = subsectors[_subsector];
		
		for (segment in subsector.segments) {
			
			var startAngle:Angle = player.angleToVertex(segment.start) - player.angle;
			var endAngle:Angle = player.angleToVertex(segment.end) - player.angle;
			var span:Angle = startAngle - endAngle;
			
			var startAngleLeftFov:Angle = startAngle + (Environment.PLAYER_FOV / 2);
			if (startAngleLeftFov > Environment.PLAYER_FOV) {
				var startAngleMoved:Angle = startAngleLeftFov - Environment.PLAYER_FOV;
				if (startAngleMoved > span) continue;
				startAngle = Environment.PLAYER_FOV / 2;
			}
			
			if (span >= 180) {
				continue;
			}
			
			if (segment.lineDef.solid) {
				
				if ((Environment.PLAYER_FOV / 2 - Std.int(endAngle)) > Environment.PLAYER_FOV) {
					endAngle = -Environment.PLAYER_FOV;
				}
				
				startAngle += 90;
				endAngle += 90;
				
				var x_start = angleToScreen(startAngle);
				var x_end = angleToScreen(endAngle);
				
				x_end = Std.int(Math.min(x_end, hwidth));
				
				for (x in x_start...x_end) {
					if (hor_walldraw[x] == true || hor_walldraw[x] == null) {
						continue;
					} else {
						hor_walldraw[x] = true;
						segment.visible = true;
					}
				}
				
			}
		}
		
		checkScreenFill();
	}
	
	function checkScreenFill() 
	{
		hor_walldraw.resize(hwidth);
		for (x in 0...(hwidth + 1)) {
			if (hor_walldraw[x] == true) {
				continue;
			} else {
				return;
			}
		}
		scanning = false;
	}
	
	function angleToScreen(_angle:Angle):Int {
		var fov = 90;
		var x = 0;
		var angle = _angle;
		if (angle > fov) {
			angle -= fov;
			x = Std.int(hwidth / 2) - Std.int(Math.tan(angle.toRadians() * 160));
		} else {
			angle = fov - Std.int(angle);
			x = Std.int(Math.tan(angle.toRadians()) * 160);
			x += 160;
		}
		return x;
	}
	
	public function getPlayerSubsector():SubSector {
		var node:Int = nodes.length - 1;
		while (true) {
			if (node & Node.SUBSECTORIDENTIFIER > 0) {
				return subsectors[node & (~Node.SUBSECTORIDENTIFIER)];
			}
			var isOnBack:Bool = isPointOnBackSide(actors_players[0].xpos, actors_players[0].ypos, node);
			if (isOnBack) {
				node = nodes[node].backChildID;
			} else {
				node = nodes[node].frontChildID;
			}
		}
	}
	
	public function getPlayerNode():Int {
		var node:Int = nodes.length - 1;
		while (true) {
			var isOnBack:Bool = isPointOnBackSide(actors_players[0].xpos, actors_players[0].ypos, node);
			if (isOnBack) {
				if (nodes[node].backChildID & Node.SUBSECTORIDENTIFIER > 0) {
					return node;
				}
				node = nodes[node].backChildID;
			} else {
				if (nodes[node].frontChildID & Node.SUBSECTORIDENTIFIER > 0) {
					return node;
				}
				node = nodes[node].frontChildID;
			}
		}
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
	
	public function isPointOnBackSide(_x:Float, _y:Float, _nodeID:Int):Bool
	{
		var dx = _x - nodes[_nodeID].xPartition;
		var dy = _y - nodes[_nodeID].yPartition;
		
		return (((dx *  nodes[_nodeID].changeYPartition) - (dy * nodes[_nodeID].changeXPartition)) <= 0);
	}
	
	public function buildNodes(_node:Int) {
		var node = nodes[_node];
		if (node.frontChildID & Node.SUBSECTORIDENTIFIER == 0) {
			nodes[node.frontChildID].parent = _node;
			buildNodes(node.frontChildID);
		}
		if (node.backChildID & Node.SUBSECTORIDENTIFIER == 0) {
			nodes[node.backChildID].parent = _node;
			buildNodes(node.backChildID);
		}
	}
	
	public function copy():BSPMap {
		var _bsp:BSPMap = new BSPMap(this.dirOffset);
		
		_bsp.linedefs = linedefs.copy();
		_bsp.name = name;
		_bsp.nodes = nodes.copy();
		_bsp.offset_x = offset_x;
		_bsp.offset_y = offset_y;
		_bsp.sectors = sectors.copy();
		_bsp.segments = segments.copy();
		_bsp.sidedefs = sidedefs.copy();
		_bsp.subsectors = subsectors.copy();
		_bsp.things = things.copy();
		_bsp.vertexes = vertexes.copy();
		_bsp.parseThings();
		
		return _bsp;
	}
	
}