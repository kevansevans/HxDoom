package hxdoom.core.action;

import hxdoom.component.Actor;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.SubSector;
import hxdoom.enums.eng.BoundBox;
import hxdoom.Engine;
import hxdoom.enums.game.ActorFlags;

/**
 * ...
 * @author Kaelan
 */
class Map 
{

	public static var TryMove:(Actor, Float, Float) -> Bool = P_TryMove;
	public static function P_TryMove(_actor:Actor, _x:Float, _y:Float):Bool
	{
		Engine.log(["Not finished here"]);
		
		var oldx:Float;
		var oldy:Float;
		var side:Int;
		var oldside:Int;
		var line:LineDef;
		
		Extern.floatok = false;
		
		//solid wall check
		if (!CheckPosition(_actor, _x, _y)) return false;
		
		//can it fit
		if (_actor.flags & ActorFlags.NOCLIP == 0) {
			if (Extern.tmceilingz - Extern.tmfloorz < _actor.height) return false;
		}
		
		Extern.floatok = true;
		
		//needs to lower?
		if (_actor.flags & ActorFlags.TELEPORT == 0 && Extern.tmceilingz - Extern.tmfloorz < _actor.height) return false;
		
		//Step up too big?
		if (_actor.flags & ActorFlags.TELEPORT == 0 && Extern.tmfloorz - _actor.zpos > 24) return false;
		
		//Drop off too high?
		if (_actor.flags & (ActorFlags.DROPOFF | ActorFlags.FLOAT) == 0 && Extern.tmfloorz - Extern.tmdropoffz > 24) return false;
		
		MapUtils.UnsetThingPosition(_actor);
		
		oldx = _actor.xpos;
		oldy = _actor.ypos;
		_actor.floorz = Extern.tmfloorz;
		_actor.ceilingz = Extern.tmceilingz;
		_actor.xpos = _x;
		_actor.ypos = _y;
		
		MapUtils.SetThingPosition(_actor);
		
		//p_map.c line 500
		if (_actor.flags & (ActorFlags.TELEPORT | ActorFlags.NOCLIP) == 0) {
			while (Extern.numspechit-- > 0)
			{
				line = Extern.spechit[Extern.numspechit];
				side = MapUtils.PointOnLineSide(_actor.xpos, _actor.ypos, line);
				oldside = MapUtils.PointOnLineSide(oldx, oldy, line);
				if (side != oldside) {
					if (line.lineType > 0) {
						Spec.CrossSpecialLine(line, oldside, _actor);
					}
				}
			}
		}
		
		return true;
		
	}
	
	public static var CheckPosition:(Actor, Float, Float) -> Bool = P_CheckPosition;
	public static function P_CheckPosition(_actor:Actor, _x:Float, _y:Float):Bool
	{
		Engine.log(["Not finished here"]);
		
		var xl:Int;
		var xh:Int;
		var yl:Int;
		var yh:Int;
		var bx:Int;
		var by:Int;
		
		var subsec:SubSector;
		
		return true;
	}
}