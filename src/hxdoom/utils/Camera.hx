package hxdoom.utils;
import hxdoom.actors.Actor;

/**
 * ...
 * @author Kaelan
 */
class Camera 
{
	public var actorToFollow:Null<Actor>;
	
	public var xpos(get, null):Float = 0.0;
	public var ypos(get, null):Float = 0.0;
	public var zpos(get, null):Float = 0.0;
	
	public var pitch(get, null):Angle = 0;
	public var yaw(get, null):Angle = 0;
	public var roll(get, null):Angle = 0;
	
	public function new(?_follow:Actor) 
	{
		actorToFollow = _follow;
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
		if (actorToFollow == null) {
			return pitch;
		} else {
			return actorToFollow.pitch;
		}
	}
	
	function get_yaw():Angle 
	{
		if (actorToFollow == null) {
			return yaw;
		} else {
			return actorToFollow.yaw;
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