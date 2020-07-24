package hxdoom.actors;

import hxdoom.utils.geom.Angle;
import hxdoom.lumps.map.Thing;
import hxdoom.lumps.map.Vertex;
import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 * 
 * Taking the GZDoom approach here and having each class type behave on inheritance rather than each possesing their own properties.
 */
class Actor 
{
	public static var CONSTRUCTOR:(Array<Any>) -> Actor = Actor.new;
	
	public var xpos(get, null):Float = 0.0;
	public var ypos(get, null):Float = 0.0;
	public var zpos(get, null):Float = 0.0;
	public var zpos_flight:Float;
	public var zpos_eyeheight:Float;
	public var zpos_view(get, null):Float;
	
	public var pitch(get, default):Angle = 0.0;
	public var yaw(get, default):Angle = 0.0;
	public var roll(get, default):Angle = 0.0;
	
	public var type:Int;
	public var flags:Int;
	
	public static function fromThing(_thing:Thing):Actor {
		return Actor.CONSTRUCTOR([_thing.xpos, _thing.ypos, _thing.angle, _thing.flags, _thing.type]);
	}
	
	public function new(_args:Array<Any>) 
	{
		xpos = 		_args[0];
		ypos = 		_args[1];
		yaw = 		_args[2];
		flags = 	_args[3];
		type = 		_args[4];
		pitch = 0;
	}
	
	public function angleToVertex(_vertex:Vertex):Angle {
		var vdx:Float = _vertex.xpos - this.xpos;
		var vdy:Float = _vertex.ypos - this.ypos;
		var angle:Angle = (Math.atan2(vdy, vdx) * 180 / Math.PI);
		angle = Angle.adjust(angle);
		return angle;
	}
	
	public function move(_value:Float) {
		xpos += _value * Math.cos(yaw.toRadians());
		ypos += _value * Math.sin(yaw.toRadians());
	}
	
	function get_zpos_view():Float 
	{
		return zpos + zpos_eyeheight;
	}
	
	public function get_xpos():Float 
	{
		return xpos;
	}
	
	public function get_ypos():Float 
	{
		return ypos;
	}
	
	public function get_zpos():Float
	{
		return Engine.ACTIVEMAP.getActorSubsector(this).sector.floorHeight;
	}
	
	public function get_pitch():Angle 
	{
		return pitch;
	}
	
	public function get_yaw():Angle 
	{
		return yaw;
	}
	
	public function get_roll():Angle 
	{
		return roll;
	}
	
}