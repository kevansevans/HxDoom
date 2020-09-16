package hxdoom.core.action;

import haxe.ds.Vector;
import hxdoom.Engine;
import hxdoom.component.Player;
import hxdoom.enums.eng.Direction;
import hxdoom.lumps.map.LineDef;
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
	
	
	public static var Fall:Actor -> Void = function(_mobj:Actor)
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
	
	public static var CheckMeleeRange:Actor -> Bool = function(_mobj:Actor):Bool 
	{
		
		Engine.log(["Not finished here"]);
		
		if (_mobj.target == null) return false;
		
		var pl = _mobj.target;
		
		return true;
	}
	
	public static var CheckMissileRange:Actor -> Bool = function(_mobj:Actor):Bool 
	{
		
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	//47000 is the same as 1/sqrt(2) in fixed point.
	
	public static var xspeed:Array<Fixed> = [Engine.FRACUNIT, 47000, 0, -47000, -Engine.FRACUNIT, -47000, 0, 47000];
	public static var yspeed:Array<Fixed> = [0, 47000, Engine.FRACUNIT, 47000, 0, -47000, -Engine.FRACUNIT, -47000];
	
	public static var Move:Actor -> Bool = function(_mobj:Actor):Bool 
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
	
	public static var TryWalk:Actor -> Bool = function(_mobj:Actor):Bool 
	{
		if (!Move(_mobj)) return false;
		
		_mobj.movecount = Engine.GAME.p_random() & 15;
		return true;
	}
	
	public static var NewChaseDir:Actor -> Void = function(_mobj:Actor)
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
	
	public static var LookForPlayers:(Actor, Bool) -> Bool = function(_mobj:Actor, _allaround:Bool):Bool 
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
	public static var KeenDie:Actor -> Void = function(_mobj:Actor) 
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Look:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Chase:Actor -> Void = function(_mobj:Actor) 
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FaceTarget:Actor -> Void = function(_mobj:Actor)
	{
		if (_mobj.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var PosAttack:Actor -> Void = function(_mobj:Actor)
	{
		var angle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_mobj.target == null) return;
		
		FaceTarget(_mobj);
		
		angle = Std.int(_mobj.yaw);
		
		Engine.log(["Not finished here"]);
	}
	
	public static var SPosAttack:Actor -> Void = function(_mobj:Actor)
	{
		var i:Int;
		var angle:Int;
		var bangle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_mobj.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var CPosAttack:Actor -> Void = function(_mobj:Actor)
	{
		var angle:Int;
		var bangle:Int;
		var damage:Int;
		var slope:Int;
		
		if (_mobj.target == null) return;
		
		Engine.log(["Not finished here"]);
	}
	
	public static var CPosRefire:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
		
		FaceTarget(_mobj);
		
		if (Engine.GAME.p_random() < 40) return;
	}
	
	public static var SpidRefire:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
		
		FaceTarget(_mobj);
		
		if (Engine.GAME.p_random() < 10) return;
	}
	
	public static var BspiAttack:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var TroopAttack:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SargAttack:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var HeadAttack:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var CyberAttack:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BruisAttack:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelMissile:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var TRACEANGLE:Int = 0xC000000;
	public static var Tracer:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelWhoosh:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkelFist:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	/*
	 * mobj_t*		corpsehit;
	 * mobj_t*		vileobj;
	 * fixed_t		viletryx;
	 * fixed_t		viletryy;
	 */
	
	public static var PIT_VileCheck:Actor -> Bool = function(_mobj:Actor):Bool
	{
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	public static var VileChase:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileStart:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Fire:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var StartFire:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FireCrackle:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileTarget:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var VileAttack:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatRaise:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack1:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack2:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var FatAttack3:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SkullAttack:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainShootSkull:(Actor, Angle) -> Void = function(_mobj:Actor, _angle:Angle)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainAttack:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PainDie:Actor -> Void = function(_mobj:Actor)
	{
		Fall(_mobj);
		PainShootSkull(_mobj, _mobj.yaw + 90);
		PainShootSkull(_mobj, _mobj.yaw + 180);
		PainShootSkull(_mobj, _mobj.yaw + 270);
		
		Engine.log(["Not finished here, shit likely not accurate"]);
	}
	
	public static var Scream:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var XScream:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Pain:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Explode:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BossDeath:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Hoof:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var Metal:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BabyMetal:Actor -> Void = function(_mobj:Actor)
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
	
	public static var BrainAwake:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainPain:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainScream:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainExplode:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainDie:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var BrainSpit:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SpawnFly:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SpawnSound:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PlayerScream:Actor -> Void = function(_mobj:Actor)
	{
		Engine.log(["Not finished here"]);
	}
}