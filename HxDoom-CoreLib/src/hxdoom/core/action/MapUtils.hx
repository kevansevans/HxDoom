package hxdoom.core.action;

import hxdoom.component.Actor;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Sector;

/**
 * ...
 * @author Kaelan
 */
class MapUtils //p_matutl.c
{

	public static var AproxDistance:(Float, Float) -> Float = P_AproxDistance;
	public static function P_AproxDistance(_dx:Float, _dy:Float):Float 
	{
		
		Engine.log(["Test me!"]);
		
		var dx = Math.abs(_dx);
		var dy = Math.abs(_dy);
		
		if (dx < dy) return (dx + dy - (Std.int(dx) >> 1));
		else return (dx + dy - (Std.int(dy) >> 1));
	}
	
	public static var LineOpening:LineDef -> Void = P_LineOpening;
	public static function P_LineOpening(_line:LineDef):Void
	{
		var front:Sector;
		var back:Sector;
		
		if (_line.backSideDef == null) {
			Extern.openrange = 0;
			return;
		}
		
		//maybe add some getters here
		front = _line.frontSideDef.sector;
		back = _line.backSideDef.sector;
		
		if (front.ceilingHeight < back.ceilingHeight) {
			Extern.opentop = front.ceilingHeight;
		} else {
			Extern.opentop = back.ceilingHeight;
		}
		
		if (front.floorHeight > back.floorHeight) {
			Extern.openbottom = front.floorHeight;
			Extern.lowfloor = back.floorHeight;
		} else {
			Extern.openbottom = back.floorHeight;
			Extern.lowfloor = front.floorHeight;
		}
		
		Extern.openrange = Extern.opentop - Extern.openbottom;
	}
	
	public static var UnsetThingPosition:Actor -> Void = P_UnsetThingPosition;
	public static function P_UnsetThingPosition(_actor:Actor):Void
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var SetThingPosition:Actor -> Void = P_UnsetThingPosition;
	public static function P_SetThingPosition(_actor:Actor):Void
	{
		Engine.log(["Not finished here"]);
	}
	
	public static var PointOnLineSide:(Float, Float, LineDef) -> Int = P_PointOnLineSide;
	public static function P_PointOnLineSide(_x:Float, _y:Float, _line:LineDef):Int
	{
		var dx:Float;
		var dy:Float;
		var left:Float;
		var right:Float;
		
		if (_line.dx == 0) {
			if (_x <= _line.start.xpos) {
				//returns 1 or 0 my ass
				return _line.dy > 0 ? 1 : 0;
			}
			return _line.dy < 0 ? 1 : 0;
		}
		
		if (_line.dy == 0) {
			if (_y <= _line.start.ypos) {
				return _line.dx < 0 ? 1 : 0;
			}
			return _line.dx > 0 ? 1 : 0;
		}
		
		dx = (_x - _line.start.xpos);
		dy = (_y - _line.start.ypos);
		
		left = _line.dy * dx;
		right = _line.dx * dy;
		
		return (right < left ? 0 : 1);
	}
}