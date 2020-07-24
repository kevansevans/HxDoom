package hxdoom.actors;

import hxdoom.lumps.map.Thing;

/**
 * ...
 * @author Kaelan
 */
class Player extends Actor
{
	public static var CONSTRUCTOR:() -> Player = Player.new;
	
	public static function fromThing(_thing:Thing):Player {
		
		var player = Player.CONSTRUCTOR();
		
		player.xpos = _thing.xpos;
		player.ypos = _thing.ypos;
		player.yaw = _thing.angle;
		player.flags = _thing.flags;
		
		return player;
	}
	
	public function new() 
	{
		super();
		
		zpos_eyeheight = 41;
	}
	
}