package hxdoom.actors;

import hxdoom.utils.enums.game.DoomID;
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
	public var xpos(get, null):Float = 0.0;
	public var ypos(get, null):Float = 0.0;
	public var zpos(get, null):Float = 0.0;
	public var zpos_flight:Float;
	public var zpos_eyeheight:Float;
	public var zpos_view(get, null):Float;
	
	public var pitch(get, default):Angle = 0.0;
	public var yaw(get, default):Angle = 0.0;
	public var roll(get, default):Angle = 0.0;
	
	public var type:DoomID;
	public var flags:Int;
	
	public var isPlayer(get, never):Bool;
	public var isMonster(get, never):Bool;
	public var isPickup(get, never):Bool;
	
	public function new(_thing:Thing) 
	{
		xpos = _thing.xpos;
		ypos = _thing.ypos;
		yaw = _thing.angle;
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
		xpos += _value * Math.cos(yaw.toRadians());
		ypos += _value * Math.sin(yaw.toRadians());
	}
	
	//getters
	function get_isMonster():Bool 
	{
		switch (type) {
			case	DoomID.M_SPIDERMASTERMIND | DoomID.M_FORMERSERGEANT | DoomID.M_CYBERDEMON |
					DoomID.M_DEADFORMERHUMAN | DoomID.M_DEADFORMERSERGEANT | DoomID.M_DEADIMP | DoomID.M_DEADDEMON |
					DoomID.M_DEADCACODEMON | DoomID.M_DEADLOSTSOUL | DoomID.M_SPECTRE | DoomID.M_ARCHVILE |
					DoomID.M_FORMERCOMMANDO | DoomID.M_REVENANT | DoomID.M_MANCUBUS | DoomID.M_ARACHNOTRON |
					DoomID.M_HELLKNIGHT | DoomID.M_PAINELEMENTAL | DoomID.M_COMMANDERKEEN | DoomID.M_WOLFSS |
					DoomID.M_SPAWNSPOT | DoomID.M_BOSSBRAIN | DoomID.M_BOSSSHOOTER | DoomID.M_IMP |
					DoomID.M_DEMON | DoomID.M_BARONOFHELL | DoomID.M_FORMERTROOPER | DoomID.M_CACODEMON |
					DoomID.M_LOSTSOUL
					:
						return true;
			default :
						return false;
		}
	}
	
	function get_isPickup():Bool 
	{
		switch (type) {
			case 	DoomID.I_AMMOCLIP | DoomID.I_BACKPACK | DoomID.I_BERSERK | DoomID.I_BLUEARMOR |
					DoomID.I_BLUEKEYCARD | DoomID.I_BLUESKULLKEY | DoomID.I_BOXOFAMMO | DoomID.I_BOXOFROCKETS |
					DoomID.I_BOXOFSHELLS | DoomID.I_CELLCHARGE | DoomID.I_CELLCHARGEPACK | DoomID.I_COMPUTERMAP |
					DoomID.I_GREENARMOR | DoomID.I_HEALTHPOTION | DoomID.I_INVISIBILITY | DoomID.I_INVULNERABILITY |
					DoomID.I_LIGHTAMPLIFICATIONVISOR | DoomID.I_MEDIKIT | DoomID.I_MEGASPHERE | DoomID.I_RADIATIONSUIT |
					DoomID.I_REDKEYCARD | DoomID.I_REDSKULLKEY | DoomID.I_ROCKET | DoomID.I_SHOTGUNSHELLS |
					DoomID.I_SOULSPHERE | DoomID.I_SPIRITARMOR | DoomID.I_STIMPACK | DoomID.I_YELLOWKEYCARD |
					DoomID.I_YELLOWSKULLKEY
					:
						return true;
			default :
				return false;
		}
	}
	
	function get_isPlayer():Bool 
	{
		switch (type) {
			case DoomID.P_PLAYERONE | DoomID.P_PLAYERTWO | DoomID.P_PLAYERTHREE | DoomID.P_PLAYERFOUR :
				return true;
			default :
				return false;
		}
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