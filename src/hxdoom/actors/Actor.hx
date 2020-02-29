package hxdoom.actors;

import hxdoom.abstracts.Angle;
import hxdoom.lumps.maplumps.Thing;
import hxdoom.lumps.maplumps.Vertex;

/**
 * ...
 * @author Kaelan
 * 
 * Taking the GZDoom approach here and having each class type behave on inheritance rather than each possesing their own properties.
 */
class Actor 
{
	public var xpos:Float;
	public var ypos:Float;
	public var xpos_look(get, null):Float;
	public var ypos_look(get, null):Float;
	public var zpos_look(get, null):Float;
	public var pitch(default, set):Angle;
	public var angle:Angle;
	public var type:TypeID;
	public var flags:Int;
	
	public var isPlayer(get, never):Bool;
	public var isMonster(get, never):Bool;
	public var isPickup(get, never):Bool;
	
	public function new(_thing:Thing) 
	{
		xpos = _thing.xpos;
		ypos = _thing.ypos;
		angle = _thing.angle;
		flags = _thing.flags;
		type = _thing.type;
		pitch = 0;
	}
	
	public function angleToVertex(_vertex:Vertex):Angle {
		var vdx:Float = _vertex.xpos - this.xpos;
		var vdy:Float = _vertex.ypos - this.ypos;
		var angle:Angle = (Math.atan2(vdy, vdx) * 180 / Math.PI);
		return angle;
	}
	
	public function move(_value:Float) {
		xpos += _value * Math.cos(angle.toRadians());
		ypos += _value * Math.sin(angle.toRadians());
	}
	
	//getters
	function get_isMonster():Bool 
	{
		switch (type) {
			case	TypeID.M_SPIDERMASTERMIND | TypeID.M_FORMERSERGEANT | TypeID.M_CYBERDEMON |
					TypeID.M_DEADFORMERHUMAN | TypeID.M_DEADFORMERSERGEANT | TypeID.M_DEADIMP | TypeID.M_DEADDEMON |
					TypeID.M_DEADCACODEMON | TypeID.M_DEADLOSTSOUL | TypeID.M_SPECTRE | TypeID.M_ARCHVILE |
					TypeID.M_FORMERCOMMANDO | TypeID.M_REVENANT | TypeID.M_MANCUBUS | TypeID.M_ARACHNOTRON |
					TypeID.M_HELLKNIGHT | TypeID.M_PAINELEMENTAL | TypeID.M_COMMANDERKEEN | TypeID.M_WOLFSS |
					TypeID.M_SPAWNSPOT | TypeID.M_BOSSBRAIN | TypeID.M_BOSSSHOOTER | TypeID.M_IMP |
					TypeID.M_DEMON | TypeID.M_BARONOFHELL | TypeID.M_FORMERTROOPER | TypeID.M_CACODEMON |
					TypeID.M_LOSTSOUL
					:
						return true;
			default :
						return false;
		}
	}
	
	function get_isPickup():Bool 
	{
		switch (type) {
			case 	TypeID.I_AMMOCLIP | TypeID.I_BACKPACK | TypeID.I_BERSERK | TypeID.I_BLUEARMOR |
					TypeID.I_BLUEKEYCARD | TypeID.I_BLUESKULLKEY | TypeID.I_BOXOFAMMO | TypeID.I_BOXOFROCKETS |
					TypeID.I_BOXOFSHELLS | TypeID.I_CELLCHARGE | TypeID.I_CELLCHARGEPACK | TypeID.I_COMPUTERMAP |
					TypeID.I_GREENARMOR | TypeID.I_HEALTHPOTION | TypeID.I_INVISIBILITY | TypeID.I_INVULNERABILITY |
					TypeID.I_LIGHTAMPLIFICATIONVISOR | TypeID.I_MEDIKIT | TypeID.I_MEGASPHERE | TypeID.I_RADIATIONSUIT |
					TypeID.I_REDKEYCARD | TypeID.I_REDSKULLKEY | TypeID.I_ROCKET | TypeID.I_SHOTGUNSHELLS |
					TypeID.I_SOULSPHERE | TypeID.I_SPIRITARMOR | TypeID.I_STIMPACK | TypeID.I_YELLOWKEYCARD |
					TypeID.I_YELLOWSKULLKEY
					:
						return true;
			default :
				return false;
		}
	}
	
	function get_xpos_look():Float 
	{
		return xpos + 5 * Math.cos(angle.toRadians());
	}
	
	function get_ypos_look():Float 
	{
		return ypos + 5 * Math.sin(angle.toRadians());
	}
	
	function get_isPlayer():Bool 
	{
		switch (type) {
			case TypeID.P_PLAYERONE | TypeID.P_PLAYERTWO | TypeID.P_PLAYERTHREE | TypeID.P_PLAYERFOUR :
				return true;
			default :
				return false;
		}
	}
	
	function get_zpos_look():Float 
	{
		return 5 * Math.sin(pitch.toRadians());
	}
	
	function set_pitch(value:Angle):Angle 
	{
		return pitch = value;
		trace(pitch);
	}
	
}