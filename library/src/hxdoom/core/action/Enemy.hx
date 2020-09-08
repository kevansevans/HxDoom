package hxdoom.core.action;

import hxdoom.Engine;
import hxdoom.component.Player;
import hxdoom.lumps.map.LineDef;
import hxdoom.utils.geom.Angle;

import hxdoom.lumps.map.Sector;
import hxdoom.component.Actor;

import hxdoom.utils.math.Fixed;

/**
 * ...
 * @author Kaelan
 */
class Enemy //p_enemy.c
{
	
	public static var Fall:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}

	public static var soundTarget:Actor;
	
	public static var RecursiveSound:(Sector, Int) -> Void = function(_sector:Sector, _soundblocks:Int) 
	{
		
		var i:Int;
		var check:LineDef;
		var other:Sector;
		
		if (_sector.validcount == Engine.validcount 
			&& _sector.soundtraversed <= _soundblocks + 1) return;
			
		_sector.validcount = Engine.validcount;
		_sector.soundtraversed = _soundblocks + 1;
		_sector.soundtarget = soundTarget;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var NoiseAlert:(Actor, Actor) -> Void = function(_target:Actor, _emmiter:Actor) 
	{
		soundTarget = _target;
		Engine.validcount++;
		RecursiveSound(_emmiter.subsector.sector, 0);
	}
	
	public static var CheckMeleeRange:Actor -> Bool = function(_mob:Actor):Bool 
	{
		
		Engine.log(["Not finished here"]);
		
		if (_mob.target == null) return false;
		
		var pl = _mob.target;
		
		return true;
	}
	
	public static var CheckMissileRange:Actor -> Bool = function(_mob:Actor):Bool 
	{
		
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	//47000 is the same as 1/sqrt(2) in fixed point.
	
	public static var xspeed:Array<Fixed> = [Engine.FRACUNIT, 47000, 0, -47000, -Engine.FRACUNIT, -47000, 0, 47000];
	public static var yspeed:Array<Fixed> = [0, 47000, Engine.FRACUNIT, 47000, 0, -47000, -Engine.FRACUNIT, -47000];
	
	public static var Move:Actor -> Bool = function(_mob:Actor):Bool 
	{
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	public static var TryWalk:Actor -> Bool = function(_mob:Actor):Bool 
	{
		if (!Move(_mob)) return false;
		
		_mob.movecount = Engine.GAME.p_random() & 15;
		return true;
	}
	
	public static var NewChaseDir:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var LookForPlayers:(Actor, Bool) -> Bool = function(_mob:Actor, _allaround:Bool):Bool 
	{
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	//tag 666 thingy
	public static var KeenDie:Actor -> Void = function(_mob:Actor) 
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Look:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Chase:Actor -> Void = function(_mob:Actor) 
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FaceTarget:Actor -> Void = function(_mob:Actor)
	{
		if (_mob.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var PosAttack:Actor -> Void = function(_mob:Actor)
	{
		var angle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_mob.target == null) return;
		
		FaceTarget(_mob);
		
		angle = Std.int(_mob.yaw);
		
		Engine.log(["Not finished here"]);
	}
	
	public static var SPosAttack:Actor -> Void = function(_mob:Actor)
	{
		var i:Int;
		var angle:Int;
		var bangle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_mob.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var CPosAttack:Actor -> Void = function(_mob:Actor)
	{
		var angle:Int;
		var bangle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_mob.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var CPosRefire:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
		
		FaceTarget(_mob);
		
		if (Engine.GAME.p_random() < 40) return;
	}
	
	public static var SpidRefire:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
		
		FaceTarget(_mob);
		
		if (Engine.GAME.p_random() < 10) return;
	}
	
	public static var BspiAttack:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var TroopAttack:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SargAttack:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var HeadAttack:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var CyberAttack:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BruisAttack:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelMissile:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var TRACEANGLE:Int = 0xC000000;
	public static var Tracer:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelWhoosh:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelFist:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	/*
	 * mobj_t*		corpsehit;
	 * mobj_t*		vileobj;
	 * fixed_t		viletryx;
	 * fixed_t		viletryy;
	 */
	
	public static var PIT_VileCheck:Actor -> Bool = function(_mob:Actor):Bool
	{
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	public static var VileChase:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileStart:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Fire:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var StartFire:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FireCrackle:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileTarget:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileAttack:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatRaise:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack1:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack2:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack3:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkullAttack:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainShootSkull:(Actor, Angle) -> Void = function(_mob:Actor, _angle:Angle)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainAttack:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainDie:Actor -> Void = function(_mob:Actor)
	{
		Fall(_mob);
		PainShootSkull(_mob, _mob.yaw + 90);
		PainShootSkull(_mob, _mob.yaw + 180);
		PainShootSkull(_mob, _mob.yaw + 270);
		
		Engine.log(["Not finished here, shit likely not accurate"]);
	}
	
	public static var Scream:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var XScream:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Pain:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Explode:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BossDeath:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Hoof:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Metal:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BabyMetal:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var OpenShotgun:Player -> Void = function(_player:Player)
	{
		Engine.log(["Not finished here, double check argumebnts"]);
	}
	
	public static var LoadShotgun:Player -> Void = function(_player:Player)
	{
		Engine.log(["Not finished here, double check argumebnts"]);
	}
	
	public static var ReFire:Player -> Void = function(_player:Player)
	{
		Engine.log(["Not finished here, double check argumebnts"]);
	}
	
	public static var CloseShotgun2:Player -> Void = function(_player:Player)
	{
		Engine.log(["Not finished here, double check argumebnts"]);
	}
	
	public static var BrainAwake:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainPain:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainScream:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainExplode:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainDie:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainSpit:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SpawnFly:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SpawnSound:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PlayerScream:Actor -> Void = function(_mob:Actor)
	{
		Engine.log(["Not finished here"]);
	}
}