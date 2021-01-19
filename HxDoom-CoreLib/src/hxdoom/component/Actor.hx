package hxdoom.component;

import hxdoom.lumps.map.SubSector;
import hxdoom.utils.geom.Angle;
import hxdoom.lumps.map.Thing;
import hxdoom.lumps.map.Vertex;
import hxdoom.typedefs.properties.ActorFlags;
import hxdoom.Engine;
import hxdoom.typedefs.properties.ActorInfo;
import hxdoom.enums.eng.MoveDirection;

/**
 * ...
 * @author Kaelan
 * 
 * Taking the GZDoom approach here and having each class type behave on inheritance rather than each possesing their own properties.
 */
class Actor 
{
	public static var CONSTRUCTOR:() -> Actor = Actor.new;
	
	public var type:Int = 0;
	
	public var xpos(get, default):Float = 0.0;
	public var ypos(get, default):Float = 0.0;
	public var zpos(get, default):Float = 0.0;
	public var zpos_flight:Float;
	public var zpos_eyeheight:Float;
	public var zpos_view(get, null):Float;
	public var deltaviewheight:Float;
	
	public var movedir:MoveDirection = NO_DIRECTION;
	
	public var momx:Float = 0;
	public var momy:Float = 0;
	public var momz:Float = 0;
	
	public var slidex:Float;
	public var slidey:Float;
	
	public var floorz:Float;
	public var ceilingz:Float;
	
	public var subsector(get, null):SubSector;
	
	public var pitch(get, default):Angle = 0.0;
	public var yaw(get, default):Angle = 0.0;
	public var roll(get, default):Angle = 0.0;
	
	public var health:Int;
	public var height:Int;
	
	public var flags:ActorFlags = {};
	public var info:ActorInfo = {};
	
	public var target:Null<Actor>;
	
	public var justhit:Bool = false;
	
	public var movecount:Int = 0;
	
	public var isPlayer:Bool = false;
	
	public static function fromThing(_thing:Thing):Actor {
		
		var actor = Actor.CONSTRUCTOR();
		
		actor.xpos = _thing.xpos;
		actor.ypos = _thing.ypos;
		actor.yaw = _thing.angle;
		
		return actor;
	}
	
	public function new() 
	{
		//Actor.hx to assume unknown class
	}
	
	public function angleToVertex(_vertex:Vertex):Angle {
		var vdx:Float = _vertex.xpos - this.xpos;
		var vdy:Float = _vertex.ypos - this.ypos;
		var angle:Angle = (Math.atan2(vdy, vdx) * 180 / Math.PI);
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
		return Engine.LEVELS.currentMap.getActorSubsector(this).sector.floorHeight;
	}
	
	public function get_subsector():SubSector 
	{
		return Engine.LEVELS.currentMap.getActorSubsector(this);
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