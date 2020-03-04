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
	
	public function build() {
		parseThings();
		setOffset();
		buildNodes(nodes.length - 1);
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