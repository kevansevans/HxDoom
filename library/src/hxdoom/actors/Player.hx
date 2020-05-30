package hxdoom.actors;

import hxdoom.lumps.map.Thing;

/**
 * ...
 * @author Kaelan
 */
class Player extends Actor
{
	public function new(_thing:Thing) 
	{
		super(_thing);
		
		zpos_eyeheight = 41;
	}
	
}