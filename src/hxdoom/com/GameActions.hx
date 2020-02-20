package hxdoom.com;

import hxdoom.Engine;
import hxdoom.com.Environment;

/**
 * ...
 * @author Kaelan
 */
class GameActions 
{
	//Cheat Specific actions
	static public function cheat_logPlayerPosition() {
		Engine.log("x: " + Engine.ACTIVEMAP.actors_players[0].xpos);
		Engine.log("y: " + Engine.ACTIVEMAP.actors_players[0].ypos);
	}
	static public function cheat_degreeless() {
		Environment.CHEAT_INVULNERABILITY = !Environment.CHEAT_INVULNERABILITY;
		switch (Environment.CHEAT_INVULNERABILITY) {
			case true :
				trace("Degreeless mode on");
			case false :
				trace("Degreeless mode off");
		}
	}
	static public function cheat_clipping() {
		Environment.CHEAT_CLIPPING = !Environment.CHEAT_CLIPPING;
		switch (Environment.CHEAT_CLIPPING) {
			case true :
				trace("Noclip on");
			case false :
				trace("Noclip off");
		}
	}
}