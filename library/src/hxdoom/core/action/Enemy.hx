package hxdoom.core.action;

import haxe.ds.Vector;
import hxdoom.Engine;
import hxdoom.component.Player;
import hxdoom.enums.eng.Direction;
import hxdoom.enums.game.ActorFlags;
import hxdoom.lumps.map.LineDef;
import hxdoom.typedefs.internal.PlayerSprite;
import hxdoom.utils.geom.Angle;

import hxdoom.lumps.map.Sector;
import hxdoom.component.Actor;

import hxdoom.utils.math.Fixed;
import haxe.Int64;

/**
 * ...
 * @author Kaelan
 */
class Enemy //p_enemy.c
{
	public static var opposite:Array<Direction> = [Direction.West, Direction.SouthWest, Direction.South, Direction.SouthEast, Direction.East, Direction.NorthEast, Direction.North, Direction.NorthWest, Direction.NoDir];
	public static var diags:Array<Direction> = [Direction.NorthWest, Direction.NorthEast, Direction.SouthWest, Direction.SouthEast];
	
	public static var Fall:Actor -> Void = A_Fall;
	public static function A_Fall(_mobj:Actor)
	{
		_mobj.flags &= ~ActorFlags.SOLID;
	}

	public static var soundTarget:Actor;
	
	public static var RecursiveSound:(Sector, Int) -> Void = P_RecursiveSound;
	public static function P_RecursiveSound(_sector:Sector, _soundblocks:Int) 
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
	
	public static var NoiseAlert:(Actor, Actor) -> Void = P_NoiseAlert;
	public static function P_NoiseAlert(_target:Actor, _emmiter:Actor) 
	{
		soundTarget = _target;
		Engine.validcount++;
		RecursiveSound(_emmiter.subsector.sector, 0);
	}
	
	public static var CheckMeleeRange:Actor -> Bool = P_CheckMeleeRange;
	public static function P_CheckMeleeRange(_mobj:Actor):Bool 
	{
		
		Engine.log(["Not finished here"]);
		
		if (_mobj.target == null) return false;
		
		var pl = _mobj.target;
		
		return true;
	}
	
	public static var CheckMissileRange:Actor -> Bool = P_CheckMissileRange;
	public static function P_CheckMissileRange(_mobj:Actor):Bool 
	{
		
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	//47000 is the same as 1/sqrt(2) in fixed point.
	
	public static var xspeed:Array<Fixed> = [Engine.FRACUNIT, 47000, 0, -47000, -Engine.FRACUNIT, -47000, 0, 47000];
	public static var yspeed:Array<Fixed> = [0, 47000, Engine.FRACUNIT, 47000, 0, -47000, -Engine.FRACUNIT, -47000];
	
	public static var Move:Actor -> Bool = P_Move;
	public static function P_Move(_mobj:Actor):Bool 
	{
		var tryx:Fixed; 
		var tryy:Fixed;
		
		var ld:LineDef;
		
		var try_ok:Bool;
		var good:Bool;
		
		//if actor doesn't have a move direction, return false
		
		tryx = Int64.fromFloat(_mobj.info.speed * xspeed[_mobj.movedir]).low;
		tryy = Int64.fromFloat(_mobj.info.speed * yspeed[_mobj.movedir]).low;
		
		try_ok = false;
		
		if (!try_ok) {
			
		}
		
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	public static var TryWalk:Actor -> Bool = P_TryWalk;
	public static function P_TryWalk(_mobj:Actor):Bool
	{
		if (!Move(_mobj)) return false;
		
		_mobj.movecount = Engine.GAME.p_random() & 15;
		return true;
	}
	
	public static var NewChaseDir:Actor -> Void = P_NewChaseDir;
	public static function P_NewChaseDir(_mobj:Actor)
	{
		Engine.log(["I need testing!"]);
		
		if (_mobj.target == null) {
			Engine.log(["NewChaseDir: called with no target"]);
			return;
		}
		
		var deltax:Fixed;
		var deltay:Fixed;
		var d:Vector<Direction> = new Vector(2);
		var tdir:Int;
		var olddir:Direction;
		var turnaround:Direction;
		
		olddir = _mobj.movedir;
		turnaround = opposite[olddir];
		
		deltax = Int64.fromFloat(_mobj.target.xpos - _mobj.xpos).low;
		deltay = Int64.fromFloat(_mobj.target.ypos - _mobj.ypos).low;
		
		if (deltax > 10 * Engine.FRACUNIT) d[0] = Direction.East;
		else if (deltax < -10 * Engine.FRACUNIT) d[0] = Direction.West;
		else d[0] = Direction.NoDir;
		
		if (deltay < -10 * Engine.FRACUNIT) d[1] = Direction.South;
		else if (deltay > 10 * Engine.FRACUNIT) d[1] = Direction.North;
		else d[1] = Direction.NoDir;
		
		if (d[0] != Direction.NoDir && d[1] != Direction.NoDir) {
			//Original source: actor->movedir = diags[((deltay < 0)<<1)+(deltax>0)];
			_mobj.movedir = diags[((deltay < 0 == true ? 1 : 0) << 1) + (deltax > 0 == true ? 1 : 0)];
			if (_mobj.movedir != turnaround && TryWalk(_mobj)) {
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
			if (TryWalk(_mobj)) {
				return;
			}
		}
		
		if (d[1] != Direction.NoDir) {
			_mobj.movedir = d[1];
			if (TryWalk(_mobj)) return;
		}
		
		if (olddir != Direction.NoDir) {
			_mobj.movedir = olddir;
			if (TryWalk(_mobj)) return;
		}
		
		if (Engine.GAME.p_random() & 1 > 1) {
			for (tdir in Direction.East...Direction.SouthEast) {
				if (tdir != turnaround) {
					_mobj.movedir = tdir;
					if (TryWalk(_mobj)) return;
				}
			}
		} else {
			for (tdir in Direction.East...Direction.SouthEast) {
				if (Direction.SouthEast - tdir != turnaround) {
					_mobj.movedir = tdir;
					if (TryWalk(_mobj)) return;
				}
			}
		}
		
		if (turnaround != Direction.NoDir) {
			_mobj.movedir = turnaround;
			if (TryWalk(_mobj)) return;
		}
		
		_mobj.movedir = Direction.NoDir;
	}
	
	public static var LookForPlayers:(Actor, Bool) -> Bool = P_LookForPlayers; 
	public static function P_LookForPlayers(_mobj:Actor, _allaround:Bool):Bool 
	{
		Engine.log(["Not finished here"]);
		
		var c:Int;
		var stop:Int;
		var player:Player;
		var sector:Sector;
		var an:Angle;
		var distance:Fixed;
		
		sector = _mobj.subsector.sector;
		
		c = 0;
		stop = (_mobj.lastlook - 1) & 3;
		
		for (p_index in 0...3) {
			_mobj.lastlook = p_index;
			
			if (Engine.LEVELS.currentMap.actors_players[_mobj.lastlook] == null) continue;
			
			if (c++ == 2 || _mobj.lastlook == stop) return false;
			
			player = Engine.LEVELS.currentMap.actors_players[_mobj.lastlook];
			
			if (player.health <= 0) continue;
			
			//check if out of sight here
			
			if (!_allaround) {
				//maths stuffs here
			}
			
			_mobj.target = player;
			return true;
		}
		
		return false;
	}
	
	//tag 666 thingy
	//this needs to be adapted into a more generalized function
	public static var KeenDie:Actor -> Void = A_KeenDie;
	public static function A_KeenDie(_mobj:Actor) 
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Look:Actor -> Void = A_Look;
	public static function A_Look(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Chase:Actor -> Void = A_Chase; 
	public static function A_Chase(_mobj:Actor) 
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FaceTarget:Actor -> Void = A_FaceTarget;
	public static function A_FaceTarget(_mobj:Actor)
	{
		if (_mobj.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var PosAttack:Actor -> Void = A_PosAttack;
	public static function A_PosAttack(_mobj:Actor)
	{
		var angle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_mobj.target == null) return;
		
		FaceTarget(_mobj);
		
		angle = Std.int(_mobj.yaw);
		
		Engine.log(["Not finished here"]);
	}
	
	public static var SPosAttack:Actor -> Void = A_SPosAttack;
	public static function A_SPosAttack(_mobj:Actor)
	{
		var i:Int;
		var angle:Int;
		var bangle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_mobj.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var CPosAttack:Actor -> Void = A_CPosAttack;
	public static function A_CPosAttack(_mobj:Actor)
	{
		var angle:Int;
		var bangle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_mobj.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var CPosRefire:Actor -> Void = A_CPosRefire;
	public static function A_CPosRefire(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
		
		FaceTarget(_mobj);
		
		if (Engine.GAME.p_random() < 40) return;
	}
	
	public static var SpidRefire:Actor -> Void = A_SpidRefire;
	public static function A_SpidRefire(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
		
		FaceTarget(_mobj);
		
		if (Engine.GAME.p_random() < 10) return;
	}
	
	public static var BspiAttack:Actor -> Void = A_BspiAttack;
	public static function A_BspiAttack(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var TroopAttack:Actor -> Void = A_TroopAttack;
	public static function A_TroopAttack(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SargAttack:Actor -> Void = A_SargAttack;
	public static function A_SargAttack(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var HeadAttack:Actor -> Void = A_HeadAttack;
	public static function A_HeadAttack(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var CyberAttack:Actor -> Void = A_CyberAttack;
	public static function A_CyberAttack(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BruisAttack:Actor -> Void = A_BruisAttack;
	public static function A_BruisAttack(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelMissile:Actor -> Void = A_SkelMissile;
	public static function A_SkelMissile(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var TRACEANGLE:Int = 0xC000000;
	
	public static var Tracer:Actor -> Void = A_Tracer;
	public static function A_Tracer(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelWhoosh:Actor -> Void = A_SkelWhoosh;
	public static function A_SkelWhoosh(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelFist:Actor -> Void = A_SkelFist;
	public static function A_SkelFist(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	/*
	 * mobj_t*		corpsehit;
	 * mobj_t*		vileobj;
	 * fixed_t		viletryx;
	 * fixed_t		viletryy;
	 */
	
	public static var VileCheck:Actor -> Bool = PIT_VileCheck;
	public static function PIT_VileCheck(_mobj:Actor):Bool
	{
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	public static var VileChase:Actor -> Void = A_VileChase;
	public static function A_VileChase(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileStart:Actor -> Void = A_VileStart;
	public static function A_VileStart(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Fire:Actor -> Void = A_Fire;
	public static function A_Fire(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var StartFire:Actor -> Void = A_StartFire;
	public static function A_StartFire(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FireCrackle:Actor -> Void = A_FireCrackle;
	public static function A_FireCrackle(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileTarget:Actor -> Void = A_VileTarget;
	public static function A_VileTarget(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileAttack:Actor -> Void = A_VileAttack;
	public static function A_VileAttack(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatRaise:Actor -> Void = A_FatRaise;
	public static function A_FatRaise(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack1:Actor -> Void = A_FatAttack1;
	public static function A_FatAttack1(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack2:Actor -> Void = A_FatAttack2;
	public static function A_FatAttack2(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack3:Actor -> Void = A_FatAttack3;
	public static function A_FatAttack3(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkullAttack:Actor -> Void = A_SkullAttack;
	public static function A_SkullAttack(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainShootSkull:(Actor, Angle) -> Void = A_PainShootSkull;
	public static function A_PainShootSkull(_mobj:Actor, _angle:Angle)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainAttack:Actor -> Void = A_PainAttack;
	public static function A_PainAttack(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainDie:Actor -> Void = A_PainDie;
	public static function A_PainDie(_mobj:Actor)
	{
		Fall(_mobj);
		PainShootSkull(_mobj, _mobj.yaw + 90);
		PainShootSkull(_mobj, _mobj.yaw + 180);
		PainShootSkull(_mobj, _mobj.yaw + 270);
		
		Engine.log(["Not finished here, shit likely not accurate"]);
	}
	
	public static var Scream:Actor -> Void = A_Scream;
	public static function A_Scream(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var XScream:Actor -> Void = A_XScream;
	public static function A_XScream(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Pain:Actor -> Void = A_Pain;
	public static function A_Pain(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Explode:Actor -> Void = A_Explode;
	public static function A_Explode(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BossDeath:Actor -> Void = A_BossDeath;
	public static function A_BossDeath(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Hoof:Actor -> Void = A_Hoof;
	public static function A_Hoof(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Metal:Actor -> Void = A_Metal;
	public static function A_Metal(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BabyMetal:Actor -> Void = A_BabyMetal;
	public static function A_BabyMetal(_mobj:Actor)
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
	public static function A_BrainAwake(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainPain:Actor -> Void = A_BrainAwake;
	public static function A_BrainPain(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainScream:Actor -> Void = A_BrainScream;
	public static function A_BrainScream(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainExplode:Actor -> Void = A_BrainExplode;
	public static function A_BrainExplode(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainDie:Actor -> Void = A_BrainDie;
	public static function A_BrainDie(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainSpit:Actor -> Void = A_BrainSpit;
	public static function A_BrainSpit(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SpawnFly:Actor -> Void = A_SpawnFly;
	public static function A_SpawnFly(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SpawnSound:Actor -> Void = A_SpawnSound;
	public static function A_SpawnSound(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PlayerScream:Actor -> Void = A_PlayerScream;
	public static function A_PlayerScream(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
}