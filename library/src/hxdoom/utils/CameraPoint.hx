package hxdoom.utils;
import hxdoom.actors.Actor;

/**
 * ...
 * @author Kaelan
 */
class CameraPoint 
{
	/*
	 * This @:isVars are only here because haxe for some reason would not let me leave these as getters AND
	 * write to them. So we've got useless setter functions bloating my source. Ew.
	 */
	@:isVar public var x(get, set):Float;
	@:isVar public var y(get, set):Float;
	@:isVar public var z(get, set):Float;
	
	public var follow:Actor;
	
	public function new(_x:Float = 0, _y:Float = 0, _z:Float = 0) 
	{
		x = _x;
		y = _y;
		z = _z;
	}
	
	function get_x():Float 
	{
		if (follow == null) {
			return x;
		} else {
			return follow.xpos;
		}
	}
	
	function get_y():Float 
	{
		if (follow == null) {
			return y;
		} else {
			return follow.ypos;
		}
	}
	
	function get_z():Float 
	{
		if (follow == null) {
			return z;
		} else {
			return follow.zpos;
		}
	}
	
	function set_x(value:Float) {
		return x = value;
	}
	
	function set_y(value:Float) {
		return y = value;
	}
	
	function set_z(value:Float) {
		return z = value;
	}
	
	public static function fromActor(_actor:Actor):CameraPoint {
		return new CameraPoint(_actor.xpos, _actor.ypos, _actor.zpos);
	}
}