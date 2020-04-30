package hxdoom.utils;

import hxdoom.actors.Actor;
import hxdoom.lumps.map.Vertex;
import hxdoom.utils.geom.Angle;

/**
 * ...
 * @author Kaelan
 */
class Camera
{
	public var actorToFollow:Null<Actor>;
	public var cameraPoint:Null<CameraPoint>;
	
	public var xpos(get, null):Float = 0.0;
	public var ypos(get, null):Float = 0.0;
	public var zpos(get, null):Float = 0.0;
	
	public var pitch(get, null):Angle = 0;
	public var yaw(get, null):Angle = 0;
	public var roll(get, null):Angle = 0;
	
	public function new(?_follow:Actor, ?_pointingAt:CameraPoint) 
	{
		actorToFollow = _follow;
		cameraPoint = _pointingAt;
	}
	
	public function angleToVertex(_vertex:Vertex):Angle {
		var vdx:Float = _vertex.xpos - this.xpos;
		var vdy:Float = _vertex.ypos - this.ypos;
		var angle:Angle = (Math.atan2(vdy, vdx) * 180 / Math.PI);
		return angle;
	}
	
	function get_xpos():Float 
	{
		if (actorToFollow == null) {
			return xpos;
		} else {
			return actorToFollow.xpos;
		}
	}
	
	function get_ypos():Float 
	{
		if (actorToFollow == null) {
			return ypos;
		} else {
			return actorToFollow.ypos;
		}
	}
	
	function get_zpos():Float 
	{
		if (actorToFollow == null) {
			return zpos;
		} else {
			return actorToFollow.zpos_view;
		}
	}
	
	function get_pitch():Angle 
	{
		if (cameraPoint == null) {
			if (actorToFollow == null) {
				return pitch;
			} else {
				return actorToFollow.pitch;
			}
		} else {
			return pitch;
		}
	}
	
	function get_yaw():Angle 
	{
		if (cameraPoint == null) {
			if (actorToFollow == null) {
				return yaw;
			} else {
				return actorToFollow.yaw;
			}
		} else {
			var newx = cameraPoint.x - this.xpos;
			var newy = cameraPoint.y - this.ypos;
			var angle:Angle = Math.atan2(newy, newx) * (180 / Math.PI);
			return(angle);
		}
	}
	
	function get_roll():Angle 
	{
		if (actorToFollow == null) {
			return roll;
		} else {
			return actorToFollow.roll;
		}
	}
	
}