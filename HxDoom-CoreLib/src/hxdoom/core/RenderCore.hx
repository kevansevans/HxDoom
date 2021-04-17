package hxdoom.core;

import h2d.col.Point;
import haxe.ds.Map;
import hxd.Math;
import hxdoom.component.LevelMap;
import hxdoom.lumps.map.Vertex;

import hxdoom.Engine;
import hxdoom.lumps.map.Node;
import hxdoom.lumps.map.Segment;
import hxdoom.lumps.map.SubSector;
import hxdoom.component.Camera;
import hxdoom.enums.data.Defaults;
import hxdoom.utils.geom.Angle;

/**
 * ...
 * @author Kaelan
 */
class RenderCore
{
	public var virtual_screen:Map<Int, Segment>;
	public var vis_segments:Array<Segment>;
	public var vis_floors:Array<Segment>;
	public var screen_width:Int = 320;
	public var spanlimit:Int = 180;
	public var scanning:Bool = false;
	
	public function new() 
	{
		virtual_screen = new Map();
	}
	
	public function initScene() {}
	
	public function resize(_width:Int, _height:Int) {}
	
	public function setVisibleSegments(?_subsec:Int) {
		
		if (Engine.LEVELS.currentMap == null) return;
		
		var map = Engine.LEVELS.currentMap;
		
		scanning = true;
		if (_subsec == null) {
			virtual_screen = new Map();
			vis_segments = new Array();
			recursiveNodeTraversalVisibility(map.nodes.length -1);
		} else {
			subsectorVisibilityCheck(_subsec);
		}
	}
	
	public function recursiveNodeTraversalVisibility(_nodeIndex:Int) {
		
		var map = Engine.LEVELS.currentMap;
		
		if (checkScreenFill()) return;
		
		if (_nodeIndex & Node.SUBSECTORIDENTIFIER > 0) {
			subsectorVisibilityCheck(_nodeIndex & (~Node.SUBSECTORIDENTIFIER));
			return;
		}
		
		var node = map.nodes[_nodeIndex];
		
		var isOnBack:Bool = map.isPointOnBackSide(map.actors_players[0].xpos, map.actors_players[0].ypos, _nodeIndex);
		if (isOnBack) {
			recursiveNodeTraversalVisibility(node.backChildID);
			recursiveNodeTraversalVisibility(node.frontChildID);
		} else {
			recursiveNodeTraversalVisibility(node.frontChildID);
			recursiveNodeTraversalVisibility(node.backChildID);
		}
	}
	
	public function subsectorVisibilityCheck(_subsector:Int) {
		
		var map = Engine.LEVELS.currentMap;
		
		var camera:Camera = map.camera;
		var subsector = map.subsectors[_subsector];
		
		if (subsector == null) return;
		
		for (segment in subsector.segments) {
			
			var p_fov = CVarCore.getCvar(Defaults.PLAYER_FOV);
			
			var start:Angle;
			var end:Angle;
			
			start = camera.angleToVertex(segment.start);
			end = camera.angleToVertex(segment.end);
			
			var span:Angle = start - end;
			
			if (span.asValue() > spanlimit) {
				continue;
			}
			
			
			start -= camera.yaw;
			end -= camera.yaw;
			
			var half_fov:Float = p_fov / 2;
			
			var start_moved:Angle = start + half_fov;
			
			if (start_moved > p_fov) {
				var start_angle:Angle = start_moved - p_fov;
				if (start_angle >= span) {
					continue;
				}
				start = half_fov;
			}
			var end_moved:Angle = half_fov;
			end_moved -= end;
				
			if (end_moved >  p_fov) {
				var end_angle:Angle = end_moved - p_fov;
				if (end_angle >= spanlimit) {
					continue;
				}
				end = -half_fov;
			}
				
			start += 90;
			end += 90;
				
			registerSegToScreenWidth(segment, start, end);
			
			//if (checkScreenFill()) return;
		}
	}
	
	public function registerSegToScreenWidth(_seg:Segment, _start:Angle, _end:Angle) {
		var segment = _seg;
		var x_start:Int = angleToScreen(_start, 90);
		var x_end:Int = angleToScreen(_end, 90);
				
		for (x in x_start...(x_end + 1)) {
			if (virtual_screen[x] != null) {
				continue;
			} else {
				if (segment.lineDef.solid || segment.sector.ceilingHeight <= segment.sector.floorHeight) {
					virtual_screen[x] = segment;
				}
				if (vis_segments.indexOf(segment) == -1) {
					vis_segments.push(segment);
				}
			}
		}
	}
	
	function checkScreenFill():Bool
	{
		for (x in 0...(screen_width + 1)) {
			if (virtual_screen[x] == null) {
				return false;
			}
		}
		return true;
	}
	
	public function angleToScreen(_angle:Angle, _fov:Int):Int {
		var x:Int = 0;
		if (_angle > (_fov + 45)) {
			_angle -= (_fov + 45);
			x = Std.int(CVarCore.getCvar(Defaults.SCREEN_DISTANCE_FROM_VIEWER) - Math.round(_angle.toRadians() * (screen_width / 2)));
		} else {
			_angle = (_fov + 45) - _angle.asValue();
			x = Math.round(_angle.toRadians() * (screen_width / 2));
			x += CVarCore.getCvar(Defaults.SCREEN_DISTANCE_FROM_VIEWER);
		}
		return x;
	}
	
	function set_screen_width(value:Int):Int 
	{
		return screen_width = value;
	}
	
	var subSecTris:Map<Int, Array<Vertex>>;
	
	public function buildSubsecTris() {
		
		subSecTris = new Map();
		var points:Array<Vertex> = new Array();
		
		var high:Float = Math.POSITIVE_INFINITY;
		var low:Float = Math.NEGATIVE_INFINITY;
		var left:Float = Math.POSITIVE_INFINITY;
		var right:Float = Math.NEGATIVE_INFINITY;
		
		for (vert in Engine.LEVELS.currentMap.vertexes) {
			
			if (vert.xpos < left) left = vert.xpos;
			if (vert.xpos > right) right = vert.xpos;
			
			if (vert.ypos > low) low = vert.ypos;
			if (vert.ypos < high) high = vert.ypos;
			
		}
		
		points.push(new Vertex([left, high]));
		points.push(new Vertex([right, high]));
		points.push(new Vertex([right, low]));
		points.push(new Vertex([left, low]));
		
		recursiveTriBuilder(points, Engine.LEVELS.currentMap.nodes.length -1);
	}
	
	function recursiveTriBuilder(_points:Array<Vertex>, _node:Int) {
		
		if (_node & Node.SUBSECTORIDENTIFIER > 0) {
			subSecTris[_node & (~Node.SUBSECTORIDENTIFIER)] = _points;
			return;
		}
		
		var points = sortVerticies(_points);
		
		var map = Engine.LEVELS.currentMap;
		var node:Node = map.nodes[_node];
		
		var a:Vertex = null;
		var b:Vertex = null;
		var c:Vertex = new Vertex([node.xPartition, node.yPartition]);
		var d:Vertex = new Vertex([node.xPartition + node.changeXPartition, node.yPartition + node.changeYPartition]);
		
		//intersections
		var e:Vertex = null;
		var f:Vertex = null;
		
		var high:Float = 0;
		var low:Float = 0;
		var left:Float = 0;
		var right:Float = 0;
		
		var x:Float = 0;
		var y:Float = 0;
		
		for (index in 0...points.length) {
			
			a = points[index];
			b = points[index + 1] == null ? points[0] : points[index + 1];
			
			//Math to calculate intersections.
			var a1:Float = b.ypos - a.ypos;
			var b1:Float = a.xpos - b.xpos;
			var c1:Float = a1 * a.xpos + b1 * a.ypos;
			
			var a2:Float = d.ypos - c.ypos;
			var b2:Float = c.xpos - d.xpos;
			var c2:Float = a2 * c.xpos + b2 * c.ypos;
			
			var determinant = a1 * b2 - a2 * b1;
			
			if (determinant == 0) continue;
			
			x = (b2 * c1 - b1 * c2) / determinant;
			y = (a1 * c2 - a2 * c1) / determinant;
			
			//calculate square of line currently being intersected.
			if (a.xpos >= b.xpos) {
				right = a.xpos;
				left = b.xpos;
			} else {
				right = b.xpos;
				left = a.xpos;
			}
			
			if (a.ypos >= b.ypos) {
				low = a.ypos;
				high = b.ypos;
			} else {
				low = b.ypos;
				high = a.ypos;
			}
			
			//Does this intersection lie within the segment?
			var tolerance = 0.000000000001;
			if (left - x < tolerance && x - right < tolerance && low - y < tolerance && y - high < tolerance) {
				
				//It's impossible to make more than two intersections in a convex polygon
				//Once both points are set, end the loop and put them into the new list of points
				
				if (e == null) {
					e = new Vertex([x, y]);
					continue;
				} else {
					f = new Vertex([x, y]); //<-- Eventually encounters a node that does not satisfy this condition
					break;
				}
			}
		}
		
		if (f == null) {
			throw "Null vertex!";
		}
		
		var front:Array<Vertex> = new Array();
		var back:Array<Vertex> = new Array();
		
		front.push(e);
		front.push(f);
		back.push(e);
		back.push(f);
		
		for (vert in _points) {
			
			if (map.isPointOnBackSide(vert.xpos, vert.ypos, _node)) {
				back.push(vert);
			} else {
				front.push(vert);
			}
		}
		
		recursiveTriBuilder(front, node.frontChildID);
		recursiveTriBuilder(back, node.backChildID);
		
	}
	
	function sortVerticies(_points:Array<Vertex>):Array<Vertex>
	{
		var x:Float = 0;
		var y:Float = 0;
		
		for (vert in _points) {
			x += vert.xpos;
			y += vert.ypos;
		}
		
		var centroid:Vertex = new Vertex([x / _points.length, y / _points.length]);
		
		_points.sort(function(_a:Vertex, _b:Vertex) {
			
			var a1:Float = (Math.radToDeg(Math.atan2(_a.xpos - centroid.xpos, _a.ypos - centroid.ypos)) + 360) % 360;
			var a2:Float = (Math.radToDeg(Math.atan2(_b.xpos - centroid.xpos, _b.ypos - centroid.ypos)) + 360) % 360;
			
			if (a1 - a2 > 0) return 1;
			else if (a1 - a2 < 0) return - 1;
			else return 0;
		});
		
		return _points;
	}
}