package hxdoom.core.action;

import haxe.ds.Vector;
import hxdoom.Engine;
import hxdoom.component.Player;
import hxdoom.enums.eng.Direction;
import hxdoom.enums.game.ActorFlags;
import hxdoom.enums.game.LineFlags;
import hxdoom.lumps.map.LineDef;
import hxdoom.typedefs.internal.PlayerSprite;
import hxdoom.utils.geom.Angle;

import hxdoom.lumps.map.Sector;
import hxdoom.component.Actor;

import haxe.Int64;

#if hxdgamelib
import hxdgamelib.enums.doom.DoomType;
#end

/**
 * ...
 * @author Kaelan
 */
class Enemy //p_enemy.c
{
	public static var opposite:Array<Direction> = [Direction.West, Direction.SouthWest, Direction.South, Direction.SouthEast, Direction.East, Direction.NorthEast, Direction.North, Direction.NorthWest, Direction.NoDir];
	public static var diags:Array<Direction> = [Direction.NorthWest, Direction.NorthEast, Direction.SouthWest, Direction.SouthEast];
	
	public static var Fall:Actor -> Void = A_Fall;
	public static function A_Fall(_actor:Actor)
	{
		_actor.flags &= ~ActorFlags.SOLID;
	}

	public static var soundTarget:Actor;
	
	public static var RecursiveSound:(Sector, Int) -> Void = P_RecursiveSound;
	public static function P_RecursiveSound(_sector:Sector, _soundblocks:Int) 
	{
		
		var i:Int;
		var check:LineDef;
		var other:Sector;
		
		var sides = Engine.LEVELS.currentMap.sidedefs;
		
		if (_sector.validcount == Extern.validcount 
			&& _sector.soundtraversed <= _soundblocks + 1) return;
			
		_sector.validcount = Extern.validcount;
		_sector.soundtraversed = _soundblocks + 1;
		_sector.soundtarget = soundTarget;
		
		for (line in _sector.lines) {
			
			if (line.flags & LineFlags.TWOSIDED > 0) continue;
			
			//P_LineOpening(line);
			
			//if (openrange <= 0) continue
			
			if (sides[line.frontSideDefID].sector == _sector) {
				other = sides[line.backSideDefID].sector;
			} else {
				other = sides[line.frontSideDefID].sector;
			}
			
			if (line.flags & LineFlags.SOUNDBLOCK > 0) {
				if (_soundblocks > 0) {
					P_RecursiveSound(other, 1);
				}
			} else {
				P_RecursiveSound(other, _soundblocks);
			}
		}
		
		Engine.log(["Not finished here"]);
	}
	
	public static var NoiseAlert:(Actor, Actor) -> Void = P_NoiseAlert;
	public static function P_NoiseAlert(_target:Actor, _emmiter:Actor) 
	{
		soundTarget = _target;
		Extern.validcount++;
		RecursiveSound(_emmiter.subsector.sector, 0);
	}
	
	public static var CheckMeleeRange:Actor -> Bool = P_CheckMeleeRange;
	public static function P_CheckMeleeRange(_actor:Actor):Bool 
	{
		
		Engine.log(["Check behavior"]);
		
		if (_actor.target == null) return false;
		
		var pl = _actor.target;
		var dist:Float = MapUtils.AproxDistance(pl.xpos - _actor.xpos, pl.ypos - _actor.ypos);
		
		if (dist >= Extern.MELEERANGE - 20 + pl.info.radius) return false;
		
		if (!Sight.CheckSight(_actor, _actor.target)) return false;
		
		return true;
	}
	
	public static var CheckMissileRange:Actor -> Bool = P_CheckMissileRange;
	public static function P_CheckMissileRange(_actor:Actor):Bool 
	{
		Engine.log(["I need testing!"]);
		
		var dist:Float;
		
		if (!Sight.CheckSight(_actor, _actor.target))
		return false;
		
		if (_actor.flags & ActorFlags.JUSTHIT > 0)
		{
			_actor.flags &= ~ActorFlags.JUSTHIT;
			return true;
		}
		
		if (_actor.reactiontime > 0) return false;
		
		dist = MapUtils.AproxDistance(_actor.xpos - _actor.target.xpos, _actor.ypos - _actor.target.ypos) - 64;
		
		if (_actor.info.meleestate > 0) dist -= 128;
		
		if (dist > 200) dist = 200;
		
		if (Engine.GAME.p_random() < dist) return false;
		
		return true;
	}
	
	//47000 is the same as 1/sqrt(2) in Float point.
	
	public static var xspeed:Array<Float> = [1, Math.sqrt(2), 0, -Math.sqrt(2), 1, -Math.sqrt(2), 0, Math.sqrt(2)];
	public static var yspeed:Array<Float> = [0, Math.sqrt(2), 1, Math.sqrt(2), 0, -Math.sqrt(2), 1, -Math.sqrt(2)];
	
	public static var Move:Actor -> Bool = P_Move;
	public static function P_Move(_actor:Actor):Bool 
	{
		var tryx:Float; 
		var tryy:Float;
		
		var ld:LineDef;
		
		var try_ok:Bool;
		var good:Bool;
		
		//if actor doesn't have a move direction, return false
		
		tryx = Int64.fromFloat(_actor.info.speed * xspeed[_actor.movedir]).low;
		tryy = Int64.fromFloat(_actor.info.speed * yspeed[_actor.movedir]).low;
		
		try_ok = Map.TryMove(_actor, tryx, tryy);
		
		if (!try_ok) {
			if (_actor.flags & ActorFlags.FLOAT > 0 /*&& floatok ...?*/)
			{
				if (_actor.zpos < Extern.tmfloorz) {
					_actor.zpos += Extern.FLOATSPEED;
				} else {
					_actor.zpos -= Extern.FLOATSPEED;
				}
				
				_actor.flags |= ActorFlags.INFLOAT;
			}
			
			//really wish haxe allowed bit comparing...
			if (Extern.numspechit == 0) return false;
			
			_actor.movedir = Direction.NoDir;
			good = false;
			
			while ((Extern.numspechit--) > 0) {
				ld = Extern.spechit[Extern.numspechit];
				
			}
		}
		
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	public static var TryWalk:Actor -> Bool = P_TryWalk;
	public static function P_TryWalk(_actor:Actor):Bool
	{
		if (!Move(_actor)) return false;
		
		_actor.movecount = Engine.GAME.p_random() & 15;
		return true;
	}
	
	public static var NewChaseDir:Actor -> Void = P_NewChaseDir;
	public static function P_NewChaseDir(_actor:Actor)
	{
		Engine.log(["I need testing!"]);
		
		if (_actor.target == null) {
			Engine.log(["NewChaseDir: called with no target"]);
			return;
		}
		
		var deltax:Float;
		var deltay:Float;
		var d:Vector<Direction> = new Vector(2);
		var tdir:Int;
		var olddir:Direction;
		var turnaround:Direction;
		
		olddir = _actor.movedir;
		turnaround = opposite[olddir];
		
		deltax = _actor.target.xpos - _actor.xpos;
		deltay = _actor.target.ypos - _actor.ypos;
		
		if (deltax > 10) d[0] = Direction.East;
		else if (deltax < -10) d[0] = Direction.West;
		else d[0] = Direction.NoDir;
		
		if (deltay < -10 ) d[1] = Direction.South;
		else if (deltay > 10) d[1] = Direction.North;
		else d[1] = Direction.NoDir;
		
		if (d[0] != Direction.NoDir && d[1] != Direction.NoDir) {
			//Original source: actor->movedir = diags[((deltay < 0)<<1)+(deltax>0)];
			_actor.movedir = diags[((deltay < 0 == true ? 1 : 0) << 1) + (deltax > 0 == true ? 1 : 0)];
			if (_actor.movedir != turnaround && TryWalk(_actor)) {
				return;
			}
		}
		
		if ((Engine.GAME.p_random() > 200) || Math.abs(deltay) > Math.abs(deltax)) {
			tdir = d[0];
			d[0] = d[1];
			d[1] = tdir;
		}
		
		if (d[0] == turnaround) {
			d[0] != Direction.NoDir;
			if (TryWalk(_actor)) {
				return;
			}
		}
		
		if (d[1] != Direction.NoDir) {
			_actor.movedir = d[1];
			if (TryWalk(_actor)) return;
		}
		
		if (olddir != Direction.NoDir) {
			_actor.movedir = olddir;
			if (TryWalk(_actor)) return;
		}
		
		if (Engine.GAME.p_random() & 1 > 1) {
			for (tdir in Direction.East...Direction.SouthEast) {
				if (tdir != turnaround) {
					_actor.movedir = tdir;
					if (TryWalk(_actor)) return;
				}
			}
		} else {
			for (tdir in Direction.East...Direction.SouthEast) {
				if (Direction.SouthEast - tdir != turnaround) {
					_actor.movedir = tdir;
					if (TryWalk(_actor)) return;
				}
			}
		}
		
		if (turnaround != Direction.NoDir) {
			_actor.movedir = turnaround;
			if (TryWalk(_actor)) return;
		}
		
		_actor.movedir = Direction.NoDir;
	}
	
	public static var LookForPlayers:(Actor, Bool) -> Bool = P_LookForPlayers; 
	public static function P_LookForPlayers(_actor:Actor, _allaround:Bool):Bool 
	{
		Engine.log(["Not finished here"]);
		
		var c:Int;
		var stop:Int;
		var player:Player;
		var sector:Sector;
		var an:Angle;
		var distance:Float;
		
		sector = _actor.subsector.sector;
		
		c = 0;
		stop = (_actor.lastlook - 1) & 3;
		
		for (p_index in 0...3) {
			_actor.lastlook = p_index;
			
			if (Engine.LEVELS.currentMap.actors_players[_actor.lastlook] == null) continue;
			
			if (c++ == 2 || _actor.lastlook == stop) return false;
			
			player = Engine.LEVELS.currentMap.actors_players[_actor.lastlook];
			
			if (player.health <= 0) continue;
			
			//check if out of sight here
			
			if (!_allaround) {
				//maths stuffs here
			}
			
			_actor.target = player;
			return true;
		}
		
		return false;
	}
	
	//tag 666 thingy
	//this needs to be adapted into a more generalized function
	public static var KeenDie:Actor -> Void = A_KeenDie;
	public static function A_KeenDie(_actor:Actor) 
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Look:Actor -> Void = A_Look;
	public static function A_Look(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Chase:Actor -> Void = A_Chase; 
	public static function A_Chase(_actor:Actor) 
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FaceTarget:Actor -> Void = A_FaceTarget;
	public static function A_FaceTarget(_actor:Actor)
	{
		if (_actor.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var PosAttack:Actor -> Void = A_PosAttack;
	public static function A_PosAttack(_actor:Actor)
	{
		var angle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_actor.target == null) return;
		
		FaceTarget(_actor);
		
		angle = Std.int(_actor.yaw);
		
		Engine.log(["Not finished here"]);
	}
	
	public static var SPosAttack:Actor -> Void = A_SPosAttack;
	public static function A_SPosAttack(_actor:Actor)
	{
		var i:Int;
		var angle:Int;
		var bangle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_actor.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var CPosAttack:Actor -> Void = A_CPosAttack;
	public static function A_CPosAttack(_actor:Actor)
	{
		var angle:Int;
		var bangle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_actor.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var CPosRefire:Actor -> Void = A_CPosRefire;
	public static function A_CPosRefire(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
		
		FaceTarget(_actor);
		
		if (Engine.GAME.p_random() < 40) return;
	}
	
	public static var SpidRefire:Actor -> Void = A_SpidRefire;
	public static function A_SpidRefire(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
		
		FaceTarget(_actor);
		
		if (Engine.GAME.p_random() < 10) return;
	}
	
	public static var BspiAttack:Actor -> Void = A_BspiAttack;
	public static function A_BspiAttack(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var TroopAttack:Actor -> Void = A_TroopAttack;
	public static function A_TroopAttack(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SargAttack:Actor -> Void = A_SargAttack;
	public static function A_SargAttack(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var HeadAttack:Actor -> Void = A_HeadAttack;
	public static function A_HeadAttack(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var CyberAttack:Actor -> Void = A_CyberAttack;
	public static function A_CyberAttack(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BruisAttack:Actor -> Void = A_BruisAttack;
	public static function A_BruisAttack(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelMissile:Actor -> Void = A_SkelMissile;
	public static function A_SkelMissile(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var TRACEANGLE:Int = 0xC000000;
	
	public static var Tracer:Actor -> Void = A_Tracer;
	public static function A_Tracer(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelWhoosh:Actor -> Void = A_SkelWhoosh;
	public static function A_SkelWhoosh(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelFist:Actor -> Void = A_SkelFist;
	public static function A_SkelFist(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	/*
	 * mobj_t*		corpsehit;
	 * mobj_t*		vileobj;
	 * Float_t		viletryx;
	 * Float_t		viletryy;
	 */
	
	public static var VileCheck:Actor -> Bool = PIT_VileCheck;
	public static function PIT_VileCheck(_actor:Actor):Bool
	{
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	public static var VileChase:Actor -> Void = A_VileChase;
	public static function A_VileChase(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileStart:Actor -> Void = A_VileStart;
	public static function A_VileStart(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Fire:Actor -> Void = A_Fire;
	public static function A_Fire(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var StartFire:Actor -> Void = A_StartFire;
	public static function A_StartFire(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FireCrackle:Actor -> Void = A_FireCrackle;
	public static function A_FireCrackle(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileTarget:Actor -> Void = A_VileTarget;
	public static function A_VileTarget(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileAttack:Actor -> Void = A_VileAttack;
	public static function A_VileAttack(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatRaise:Actor -> Void = A_FatRaise;
	public static function A_FatRaise(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack1:Actor -> Void = A_FatAttack1;
	public static function A_FatAttack1(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack2:Actor -> Void = A_FatAttack2;
	public static function A_FatAttack2(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack3:Actor -> Void = A_FatAttack3;
	public static function A_FatAttack3(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkullAttack:Actor -> Void = A_SkullAttack;
	public static function A_SkullAttack(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainShootSkull:(Actor, Angle) -> Void = A_PainShootSkull;
	public static function A_PainShootSkull(_actor:Actor, _angle:Angle)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainAttack:Actor -> Void = A_PainAttack;
	public static function A_PainAttack(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainDie:Actor -> Void = A_PainDie;
	public static function A_PainDie(_actor:Actor)
	{
		Fall(_actor);
		PainShootSkull(_actor, _actor.yaw + 90);
		PainShootSkull(_actor, _actor.yaw + 180);
		PainShootSkull(_actor, _actor.yaw + 270);
		
		Engine.log(["Not finished here, shit likely not accurate"]);
	}
	
	public static var Scream:Actor -> Void = A_Scream;
	public static function A_Scream(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var XScream:Actor -> Void = A_XScream;
	public static function A_XScream(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Pain:Actor -> Void = A_Pain;
	public static function A_Pain(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Explode:Actor -> Void = A_Explode;
	public static function A_Explode(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BossDeath:Actor -> Void = A_BossDeath;
	public static function A_BossDeath(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Hoof:Actor -> Void = A_Hoof;
	public static function A_Hoof(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Metal:Actor -> Void = A_Metal;
	public static function A_Metal(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BabyMetal:Actor -> Void = A_BabyMetal;
	public static function A_BabyMetal(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var OpenShotgun2:(Player, PlayerSprite) -> Void = A_OpenShotgun2;
	public static function A_OpenShotgun2(_player:Player, _psp:PlayerSprite)
	{
		Engine.log(["Not finished here, doublecheck PlayerSprite typedef"]);
	}
	
	public static var LoadShotgun2:(Player, PlayerSprite) -> Void = A_LoadShotgun2;
	public static function A_LoadShotgun2(_player:Player, _psp:PlayerSprite)
	{
		Engine.log(["Not finished here, doublecheck PlayerSprite typedef"]);
	}
	
	public static var ReFire:(Player, PlayerSprite) -> Void = A_ReFire;
	public static function A_ReFire(_player:Player, _psp:PlayerSprite)
	{
		Engine.log(["Not finished here, doublecheck PlayerSprite typedef"]);
	}
	
	public static var CloseShotgun2:(Player, PlayerSprite) -> Void = A_CloseShotgun2;
	public static function A_CloseShotgun2(_player:Player, _psp:PlayerSprite)
	{
		Engine.log(["Not finished here, doublecheck PlayerSprite typedef"]);
	}
	
	public static var BrainAwake:Actor -> Void = A_BrainAwake;
	public static function A_BrainAwake(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainPain:Actor -> Void = A_BrainAwake;
	public static function A_BrainPain(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainScream:Actor -> Void = A_BrainScream;
	public static function A_BrainScream(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainExplode:Actor -> Void = A_BrainExplode;
	public static function A_BrainExplode(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainDie:Actor -> Void = A_BrainDie;
	public static function A_BrainDie(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainSpit:Actor -> Void = A_BrainSpit;
	public static function A_BrainSpit(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SpawnFly:Actor -> Void = A_SpawnFly;
	public static function A_SpawnFly(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SpawnSound:Actor -> Void = A_SpawnSound;
	public static function A_SpawnSound(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PlayerScream:Actor -> Void = A_PlayerScream;
	public static function A_PlayerScream(_actor:Actor)
	{
		Engine.log(["Not finished here"]);
	}
}