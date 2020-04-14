package hxdoom.core;

import haxe.ds.Map;
import hxdoom.Engine;
import hxdoom.common.Environment;
import hxdoom.utils.Angle;
import hxdoom.lumps.map.Node;
import hxdoom.lumps.map.Segment;
import hxdoom.utils.Camera;

/**
 * ...
 * @author Kaelan
 */
class RenderCore
{
	public var virtual_screen:Map<Int, Segment>;
	public var vis_segments:Array<Segment>;
	public var map(get, never):BSPMap;
	public var screen_width(default, set):Int = 320;
	public var spanlimit:Angle = 180;
	public var scanning:Bool = false;
	
	public function new() 
	{
		virtual_screen = new Map();
	}
	
	public function initScene() {}
	
	public function resize(_width:Int, _height:Int) {}
	
	public function setVisibleSegments(?_subsec:Int) {
		scanning = true;
		if (_subsec == null) {
			virtual_screen = new Map();
			vis_segments = new Array();
			recursiveNodeTraversalVisibility(map.nodes.length -1);
		} else {
			subsectorVisibilityCheck(_subsec);
		}
	}
	
	function recursiveNodeTraversalVisibility(_nodeIndex:Int) {
		
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
	
	function subsectorVisibilityCheck(_subsector:Int) {
		
		var camera:Camera = map.camera;
		var subsector = map.subsectors[_subsector];
		
		if (subsector == null) return;
		
		for (segment in subsector.segments) {
			
			var start:Angle = camera.angleToVertex(segment.start);
			var end:Angle = camera.angleToVertex(segment.end);
			var span:Angle = start - end;
			
			if (span > spanlimit) {
				continue;
			}
			
			
			start -= camera.yaw;
			end -= camera.yaw;
			
			var half_fov:Float = Environment.PLAYER_FOV / 2;
			
			var start_moved:Angle = start + half_fov;
			
			if (start_moved > Environment.PLAYER_FOV) {
				if (start_moved > span) {
					continue;
				}
				start = half_fov;
			}
			var end_moved:Angle = half_fov - Std.int(end);
				
			if (end_moved >  Environment.PLAYER_FOV) {
				end = -half_fov;
			}
				
			start += Environment.PLAYER_FOV;
			end += Environment.PLAYER_FOV;
				
			var x_start:Int = angleToScreen(start);
			var x_end:Int = angleToScreen(end);
				
			x_start = Std.int(Math.max(0, x_start));
			x_end = Std.int(Math.min(screen_width + 1, x_end));
				
			for (x in x_start...(x_end + 1)) {
				if (virtual_screen[x] != null) {
					if (segment.lineDef.solid) {
						continue;
					}
				} else {
					if (segment.lineDef.solid) {
						virtual_screen[x] = segment;
					}
					if (vis_segments.indexOf(segment) == -1) {
						vis_segments.push(segment);
					}
				}
			}
		}
		
		checkScreenFill();
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
	
	function angleToScreen(_angle:Angle):Int {
		var x:Int = 0;
		if (_angle > (Environment.PLAYER_FOV + 45)) {
			_angle -= (Environment.PLAYER_FOV + 45);
			x = Environment.SCREEN_DISTANCE_FROM_VIEWER - Math.round(_angle.toRadians() * (screen_width / 2));
		} else {
			_angle = (Environment.PLAYER_FOV + 45) - _angle.asValue();
			x = Math.round(_angle.toRadians() * (screen_width / 2));
			x += Environment.SCREEN_DISTANCE_FROM_VIEWER;
		}
		return x;
	}
	
	function get_map():BSPMap {
		return Engine.ACTIVEMAP;
	}
	
	function set_screen_width(value:Int):Int 
	{
		return screen_width = value;
	}
	
	public function render_scene() {
		
	}
}