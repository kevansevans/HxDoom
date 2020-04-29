package hxdoom.common;

import hxdoom.Engine;
import hxdoom.common.Environment;

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
		CVarCore.setCVar(EnvName.CHEAT_DEGREELESS, !CVarCore.getCvar(EnvName.CHEAT_DEGREELESS));
		switch (CVarCore.getCvar(EnvName.CHEAT_DEGREELESS)) {
			case true :
				trace("Degreeless mode on");
			case false :
				trace("Degreeless mode off");
		}
	}
	static public function cheat_clipping() {
		CVarCore.setCVar(EnvName.CHEAT_NOCLIP, !CVarCore.getCvar(EnvName.CHEAT_NOCLIP));
		switch (CVarCore.getCvar(EnvName.CHEAT_NOCLIP)) {
			case true :
				trace("Noclip on");
			case false :
				trace("Noclip off");
		}
	}
}