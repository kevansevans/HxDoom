package hxdoom.core;

import haxe.ds.Map;
import hxdoom.component.LevelMap;

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
	public var vis_subsecs:Array<SubSector>;
	public var vis_floors:Array<Segment>;
	public var screen_width(default, set):Int = 320;
	public var spanlimit:Int = 180;
	public var scanning:Bool = false;
	
	public function new() 
	{
		virtual_screen = new Map();
	}
	
	public function initScene() {}
	
	public function resize(_width:Int, _height:Int) {}
	
	public function setVisibleSegments(?_subsec:Int) {
		
		var map = Engine.LEVELS.currentMap;
		
		scanning = true;
		if (_subsec == null) {
			virtual_screen = new Map();
			vis_segments = new Array();
			vis_subsecs = new Array();
			recursiveNodeTraversalVisibility(map.nodes.length -1);
		} else {
			subsectorVisibilityCheck(_subsec);
		}
	}
	
	public function recursiveNodeTraversalVisibility(_nodeIndex:Int) {
		
		var map = Engine.LEVELS.currentMap;
		
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
			
			if (segment.side == 0) {
				start = camera.angleToVertex(segment.start);
				end = camera.angleToVertex(segment.end);
			} else {
				start = camera.angleToVertex(segment.end);
				end = camera.angleToVertex(segment.start);
			}
			
			var span:Angle = start - end;
			span = Angle.adjust(span);
			
			if (span.asValue() > spanlimit) {
				continue;
			}
			
			
			start -= camera.yaw;
			end -= camera.yaw;
			
			var half_fov:Float = p_fov / 2;
			
			var start_moved:Angle = start + half_fov;
			start_moved = Angle.adjust(start_moved);
			
			if (start_moved > p_fov) {
				if (start_moved > span) {
					continue;
				}
				start = half_fov;
			}
			var end_moved:Angle = half_fov - Std.int(end);
			end_moved = Angle.adjust(end_moved);
				
			if (end_moved >  p_fov) {
				end = -half_fov;
			}
				
			start += p_fov;
			end += p_fov;
				
			registerSegToScreenWidth(segment, start, end);
		}
	}
	
	public function registerSegToScreenWidth(_seg:Segment, _start:Angle, _end:Angle) {
		var segment = _seg;
		var x_start:Int = angleToScreen(_start, 90);
		var x_end:Int = angleToScreen(_end, 90);
				
		x_start = Std.int(Math.max(0, x_start));
		x_end = Std.int(Math.min(screen_width + 1, x_end));
				
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
	
	function checkScreenFill() 
	{
		var pass:Int = 0;
		var fail:Int = 0;
		for (x in 0...(screen_width + 1)) {
			if (virtual_screen[x] != null) {
				return;
			}
		}
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
	
	public function render_scene() {
		
	}
}