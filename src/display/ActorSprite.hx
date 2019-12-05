package display;

import openfl.display.Shape;
import openfl.display.Sprite;

import packages.actors.TypeID;

/**
 * ...
 * @author Kaelan
 */
class ActorSprite extends Sprite 
{
	var hitbox:Shape;
	var face:Shape;
	var type:Int;
	var color(get, null):Int;
	public function new(_radius:Int, _type:Int, _angle:Int) 
	{
		super();
		
		type = _type;
		
		hitbox = new Shape();
		addChild(hitbox);
		hitbox.graphics.clear();
		hitbox.graphics.beginFill(color);
		hitbox.graphics.drawRect((_radius / 2) * -1, (_radius / 2) * -1, _radius, _radius);
	}
	
	function get_color():Int 
	{
		switch(type) {
			//Players
			case TypeID.P_PLAYERONE | TypeID.P_PLAYERTWO | TypeID.P_PLAYERTHREE | TypeID.P_PLAYERFOUR:
					return 0x00FF00;
			//Monsters		
			case 	TypeID.M_SPIDERMASTERMIND | TypeID.M_FORMERSERGEANT | TypeID.M_CYBERDEMON |
					TypeID.M_DEADFORMERHUMAN | TypeID.M_DEADFORMERSERGEANT | TypeID.M_DEADIMP | TypeID.M_DEADDEMON |
					TypeID.M_DEADCACODEMON | TypeID.M_DEADLOSTSOUL | TypeID.M_SPECTRE | TypeID.M_ARCHVILE |
					TypeID.M_FORMERCOMMANDO | TypeID.M_REVENANT | TypeID.M_MANCUBUS | TypeID.M_ARACHNOTRON |
					TypeID.M_HELLKNIGHT | TypeID.M_PAINELEMENTAL | TypeID.M_COMMANDERKEEN | TypeID.M_WOLFSS |
					TypeID.M_SPAWNSPOT | TypeID.M_BOSSBRAIN | TypeID.M_BOSSSHOOTER | TypeID.M_IMP |
					TypeID.M_DEMON | TypeID.M_BARONOFHELL | TypeID.M_FORMERTROOPER | TypeID.M_CACODEMON |
					TypeID.M_LOSTSOUL
					:
						return 0xFF0000;
			//Pickups
			case 	TypeID.I_AMMOCLIP | TypeID.I_BACKPACK | TypeID.I_BERSERK | TypeID.I_BLUEARMOR |
					TypeID.I_BLUEKEYCARD | TypeID.I_BLUESKULLKEY | TypeID.I_BOXOFAMMO | TypeID.I_BOXOFROCKETS |
					TypeID.I_BOXOFSHELLS | TypeID.I_CELLCHARGE | TypeID.I_CELLCHARGEPACK | TypeID.I_COMPUTERMAP |
					TypeID.I_GREENARMOR | TypeID.I_HEALTHPOTION | TypeID.I_INVISIBILITY | TypeID.I_INVULNERABILITY |
					TypeID.I_LIGHTAMPLIFICATIONVISOR | TypeID.I_MEDIKIT | TypeID.I_MEGASPHERE | TypeID.I_RADIATIONSUIT |
					TypeID.I_REDKEYCARD | TypeID.I_REDSKULLKEY | TypeID.I_ROCKET | TypeID.I_SHOTGUNSHELLS |
					TypeID.I_SOULSPHERE | TypeID.I_SPIRITARMOR | TypeID.I_STIMPACK | TypeID.I_YELLOWKEYCARD |
					TypeID.I_YELLOWSKULLKEY
					:
						return 0x00CCFF;
			//¯\_(ツ)_/¯
			default :
				return 0xFFFFFF;
		}
	}
}