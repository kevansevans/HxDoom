package hxdgamelib.levelstruct;

import hxdoom.component.LevelMap;

import hxdgamelib.enums.doom.DoomEdNum;
import hxdoom.component.Player;
import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 */
class DoomLevel extends LevelMap 
{

	public function new() 
	{
		super();
	}
	
	override public function parseThings() 
	{
		
		actors_players = new Array();
		
		for (thing in things) {
			switch (thing.type) {
				case DoomEdNum.PLAYERONE | DoomEdNum.PLAYERTWO | DoomEdNum.PLAYERTHREE | DoomEdNum.PLAYERFOUR :
					actors_players.push(Player.fromThing(thing));
				default :
					trace("Thing type not established", thing.type);
			}
		}
	}
	
}