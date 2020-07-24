package hxdoom.utils.extensions;

import hxdoom.actors.Actor;
import hxdoom.lumps.map.Thing;
import hxdoom.lumps.map.Vertex;
import hxdoom.utils.geom.Angle;

/**
 * Camera class that follows a given actor, if provided, and points at a given camera point, if provided.
 * @author Kaelan
 */
class Camera extends Actor
{
	public var actorToFollow:Null<Actor>;
	public var cameraPoint:Null<CameraPoint>;
	
	public function new(?_follow:Actor, ?_pointingAt:CameraPoint) 
	{
		super();
		
		actorToFollow = _follow;
		cameraPoint = _pointingAt;
	}
	
	override public function get_xpos():Float 
	{
		if (actorToFollow == null) {
			return xpos;
		} else {
			return actorToFollow.xpos;
		}
	}
	
	override public function get_ypos():Float 
	{
		if (actorToFollow == null) {
			return ypos;
		} else {
			return actorToFollow.ypos;
		}
	}
	
	override public function get_zpos():Float 
	{
		if (actorToFollow == null) {
			return zpos;
		} else {
			return actorToFollow.zpos_view;
		}
	}
	
	override public function get_pitch():Angle 
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
	
	override public function get_yaw():Angle 
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
	
	override public function get_roll():Angle 
	{
		if (actorToFollow == null) {
			return roll;
		} else {
			return actorToFollow.roll;
		}
	}
	
}