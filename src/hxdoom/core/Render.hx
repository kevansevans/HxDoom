package hxdoom.core;

import haxe.ds.Vector;
import hxdoom.Engine;
import hxdoom.common.Environment;
import hxdoom.abstracts.Angle;
import hxdoom.lumps.map.Node;

/**
 * ...
 * @author Kaelan
 */
class Render 
{
	public var virtual_screen:Vector<Bool>;
	public var map(get, never):BSPMap;
	public var screen_width(default, set):Int = 320;
	public var spanlimit:Angle = 180;
	
	public function new() 
	{
		virtual_screen = new Vector(320);
	}
	
	public function setVisibleSegments() {
		for (x in 0...(screen_width + 1)) {
			virtual_screen[x] = false;
		}
		recursiveNodeTraversalVisibility(map.nodes.length -1);
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
		
		var player = map.actors_players[0];
		var subsector = map.subsectors[_subsector];
		
		for (segment in subsector.segments) {
			
			segment.visible = false;
			
			var start:Angle = player.angleToVertex(segment.start);
			var end:Angle = player.angleToVertex(segment.end);
			var span:Angle = start - end;
			
			if (span > spanlimit) {
				continue;
			}
			
			start -= player.angle;
			end -= player.angle;
			
			var half_fov:Float = Environment.PLAYER_FOV / 2;
			
			var start_moved:Angle = start + half_fov;
			
			if (start_moved > Environment.PLAYER_FOV) {
				if (start_moved > span) {
					continue;
				}
				start = half_fov;
			}
			
			if (segment.lineDef.solid) {
			
				var end_moved:Angle = half_fov - Std.int(end);
				
				if (end_moved >  Environment.PLAYER_FOV) {
					end = -half_fov;
				}
				
				start += Environment.PLAYER_FOV;
				end += Environment.PLAYER_FOV;
				
				var x_start:Int = angleToScreen(start);
				var x_end:Int = angleToScreen(end);
				
				x_start = Std.int(Math.max(0, x_start));
				x_end = Std.int(Math.min(321, x_end));
				
				for (x in x_start...(x_end + 1)) {
					if (virtual_screen[x] == true) {
						continue;
					} else {
						virtual_screen[x] = true;
						segment.visible = true;
					}
				}
			} else {
				segment.visible = true;
			}
		}
		
		checkScreenFill();
	}
	
	function checkScreenFill() 
	{
		var pass:Int = 0;
		var fail:Int = 0;
		for (x in 0...320) {
			if (virtual_screen[x] == true) {
				++pass;
			} else {
				++fail;
			}
		}
		
		if (pass >= 320) {
			trace(pass, fail);
		}
	}
	
	function angleToScreen(_angle:Angle):Int {
		var x:Int = 0;
		if (_angle > 90) {
			_angle -= 90;
			x = Environment.SCREEN_DISTANCE_FROM_VIEWER - Math.round(_angle.toRadians() * 160);
		} else {
			_angle = 90 - _angle.asValue();
			x = Math.round(_angle.toRadians() * 160);
			x += Environment.SCREEN_DISTANCE_FROM_VIEWER;
		}
		return x;
	}
	
	function get_map():BSPMap {
		return Engine.ACTIVEMAP;
	}
	
	function set_screen_width(value:Int):Int 
	{
		trace("blep");
		virtual_screen = new Vector(value);
		return screen_width = value;
	}
}