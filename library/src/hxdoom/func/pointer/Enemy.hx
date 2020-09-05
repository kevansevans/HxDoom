package hxdoom.func.pointer;

import hxdoom.Engine;

import hxdoom.lumps.map.Sector;
import hxdoom.component.Actor;

/**
 * ...
 * @author Kaelan
 */
class Enemy //p_enemy.c
{

	public static var soundTarget:Actor;
	
	public static var RecursiveSound:(Sector, Int) -> Void = function(_sector:Sector, _soundblocks:Int) 
	{
		
		//do work here
		
		Engine.log(["Not finished here"]);
	}
	
	public static var NoiseAlert:(Actor, Actor) -> Void = function(_target:Actor, _emmiter:Actor) 
	{
		
		soundTarget = _target;
		//validcount++; ???
		RecursiveSound(_emmiter.subsector.sector, 0);
		
		Engine.log(["Not finished here"]);
	}
	
	public static var CheckMeleeRange:Actor -> Bool = function(_mob:Actor):Bool 
	{
		
		Engine.log(["Not finished here"]);
		
		if (_mob.target == null) return false;
		
		return true;
	}
	
	public static var CheckMissileRange:Actor -> Bool = function(_mob:Actor):Bool 
	{
		
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	public static var Move:Actor -> Bool = function(_mob:Actor):Bool 
	{
		Engine.log(["Not finished here"]);
		
		return false;
	}
	
	public static var TryWalk:Actor -> Bool = function(_mob:Actor):Bool 
	{
		Engine.log(["Not finished here"]);
		
		if (!Move(_mob)) return false;
		
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
		FaceTarget(_mob);
	if (Engine.GAME.
	}
}