package hxdoom.actors;

import hxdoom.lumps.map.Thing;

/**
 * ...
 * @author Kaelan
 */
class Player extends Actor
{
	public static var CONSTRUCTOR:(Array<Any>) -> Player = Player.new;
	
	public static function fromThing(_thing:Thing):Player {
		return Player.CONSTRUCTOR([_thing.xpos, _thing.ypos, _thing.angle, _thing.flags, _thing.type]);
	}
	
	public function new(_args:Array<Any>) 
	{
		super(_args);
		
		zpos_eyeheight = 41;
	}
	
}