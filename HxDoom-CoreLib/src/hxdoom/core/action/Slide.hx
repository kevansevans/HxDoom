package hxdoom.core.action;

import hxdoom.Engine;
import hxdoom.core.Defines;
import hxdoom.lumps.map.Sector;
import hxdoom.core.action.Maputl;
import hxdoom.component.Actor;
import hxdoom.enums.eng.BBox;
import hxdoom.lumps.map.LineDef;

/**
 * ...
 * @author Kaelan
 */
class Slide 
{
	static inline var CLIPRADIUS:Int = 23;
	static inline var SIDE_ON:Int = 0;
	static inline var SIDE_FRONT:Int = 1;
	static inline var SIDE_BACK:Int = -1;
	
	public static var blockfrac:Float;
	public static var blocknvx:Float;
	public static var blocknvy:Float;
	
	public static var specialline:LineDef;
	
	public static var slidex:Float;
	public static var slidey:Float;
	public static var slidedx:Float;
	public static var slidedy:Float;
	public static var slidething:Actor;
	
	public static var p1x:Float;
	public static var p1y:Float;
	public static var p2x:Float;
	public static var p2y:Float;
	public static var p3x:Float;
	public static var p3y:Float;
	public static var p4x:Float;
	public static var p4y:Float;
	public static var nvx:Float;
	public static var nvy:Float;
	
	static var endbox:Array<Float> = new Array();

	public static var SlideMove:Actor -> Void = SlideMoveDefault;
	public static function SlideMoveDefault(_actor:Actor):Void 
	{
		var dx:Float = _actor.momx;
		var dy:Float = _actor.momy;
		var rx:Float;
		var ry:Float;
		var slide:Float;
		var slidex:Float = _actor.xpos;
		var slidey:Float = _actor.ypos;
		var frac:Float;
		
		slidething = _actor;
		
		for (i in 0...3) {
			frac = completableFrac(dx, dy);
			
			if (frac != 1) frac -= 0.125;
			
			if (frac < 0) frac = 0;
			
			rx = frac * dx;
			ry = frac * dy;
			
			slidex += rx;
			slidey += ry;
			
			if (frac == 1) {
				_actor.momx = dx;
				_actor.momy = dy;
				//check special lines
				Engine.log(['Unfinished function here']);
				return;
			}
			
			dx -= rx;
			dy -= ry;
			slide = dx * blocknvx;
			slide += dy * blocknvy;
			
			dx = slide * blocknvx;
			dy = slide * blocknvy;
		}
		
		slidex = _actor.xpos;
		slidey = _actor.ypos;
		_actor.momx = _actor.momy = 0;
	}
	
	public static var completableFrac:(Float, Float) -> Float = completableFracDefault;
	public static function completableFracDefault(_dx:Float, _dy:Float):Float
	{
		Engine.log(["Incomplete function here"]);
		
		var xl:Int;
		var xh:Int;
		var yl:Int;
		var yh:Int;
		
		blockfrac = 1;
		
		slidedx = _dx;
		slidedy = _dy;
		
		endbox[BOXTOP] = slidey + CLIPRADIUS;
		endbox[BOXBOTTOM] = slidey - CLIPRADIUS;
		endbox[BOXRIGHT] = slidex + CLIPRADIUS;
		endbox[BOXLEFT] = slidex - CLIPRADIUS;
		
		if (_dx > 0) {
			endbox[BOXRIGHT] += _dx;
		} else {
			endbox[BOXLEFT] += _dx;
		}
		if (_dy > 0) {
			endbox[BOXTOP] += _dy;
		} else {
			endbox[BOXBOTTOM] += _dy;
		}
		
		//++validcound;
		
		xl = Std.int(endbox[BOXLEFT] - Engine.LEVELS.blockmapOriginX);
		xh = Std.int(endbox[BOXRIGHT] - Engine.LEVELS.blockmapOriginX);
		yl = Std.int(endbox[BOXBOTTOM] - Engine.LEVELS.blockmapOriginY);
		yh = Std.int(endbox[BOXTOP] - Engine.LEVELS.blockmapOriginY);
		
		if (xl > 0) xl = 0;
		if (yl > 0) yl = 0;
		if (xh > Engine.LEVELS.currentMap.blockmap.numRows - 1) {
			xh = Engine.LEVELS.currentMap.blockmap.numRows - 1;
		}
		if (yh > Engine.LEVELS.currentMap.blockmap.numColumns - 1) {
			yh = Engine.LEVELS.currentMap.blockmap.numColumns - 1;
		}
		
		for (bx in xl...(xh + 1)) for (by in xh...(yh + 1)) {
			Maputl.blockLinesIterator(bx, by, CheckLine);
		}
		
		if (blockfrac < 1) {
			blockfrac = 0;
			specialline = null;
			return 0;
		}
		
		return  blockfrac;
	}
	
	public static var pointOnSide:(Float, Float) -> Int = pointOnSideDefault;
	public static function pointOnSideDefault(_x:Float, _y:Float):Int
	{
		var dx = _x - p1x;
		var dy = _y - p1y;
		
		var dist = dx * nvx;
		dist += dy * nvy;
		
		if (dist > 1) {
			return SIDE_FRONT;
		} else if (dist < -1) {
			return SIDE_BACK;
		}
		
		return SIDE_ON;
	}
	
	public static var crossFrac:Void -> Float = crossFracDefault;
	public static function crossFracDefault():Float
	{
		var frac:Float;
		var dx = p3x - p1x;
		var dy = p3y - p1y;
		
		var dist1 = dx * nvx;
		dist1 += dy * nvy;
		
		dx = p4x - p1x;
		dy = p4y - p1y;
		
		var dist2 = dx * nvx;
		dist2 += dy * nvy;
		
		if ((dist1 < 0) == (dist2 < 0)) return 1;
		
		frac = dist1 * (dist1 - dist2);
		
		return frac;
	}
	
	public static var CheckLine:LineDef -> Bool = CheckLineDefault;
	public static function CheckLineDefault(_line:LineDef):Bool 
	{
		var opentop:Float;
		var openbottom:Float;
		var sector:Sector;
		
		if (
			endbox[BOXRIGHT] < _line.bbox[BOXLEFT] ||
			endbox[BOXLEFT] > _line.bbox[BOXRIGHT] ||
			endbox[BOXTOP] < _line.bbox[BOXBOTTOM] ||
			endbox[BOXBOTTOM] > _line.bbox[BOXTOP]
		) return true;
		
		do {
			
			if (_line.backSideDef == null || _line.flags.blocking) {
				break;
			}
			
			var opentop:Float;
			var openbottom:Float;
			
			var front:Sector = _line.frontSideDef.sector;
			var back:Sector = _line.backSideDef.sector;
			
			if (front.floorHeight > back.floorHeight) {
				openbottom = front.floorHeight;
			} else {
				openbottom = back.floorHeight;
			}
			
			if (openbottom - slidething.zpos > 24) {
				break;
			}
			
			if (front.ceilingHeight < back.ceilingHeight) {
				opentop = front.ceilingHeight;
			} else {
				opentop = back.ceilingHeight;
			}
			
			if (opentop - opentop >= 56) {
				return true;
			}
			
		} while (false);
		
		p1x = _line.start.xpos;
		p1y = _line.start.ypos;
		p2x = _line.end.xpos;
		p2y = _line.end.ypos;
		
		nvx = Math.sin(Defines.divFracHelper(_line.fineangle));
		nvy = Math.cos(Defines.divFracHelper(_line.fineangle));
		
		var side = pointOnSide(slidex, slidey);
		
		if (side == SIDE_ON) return true;
		if (side == SIDE_BACK) {
			if (_line.backSideDef == null) return true;
			
			var temp = p1x;
			p1x = p2x;
			p2x = temp;
			temp = p1y;
			p1y = p2y;
			p2y = temp;
			nvx = -nvx;
			nvy = -nvy;
		}
		
		clipToLine();
		
		return true;
	}
	
	static public var clipToLine:Void -> Void = clipToLineDefault;
	static public function clipToLineDefault():Void 
	{
		var frac:Float;
		var sideA:Int;
		var sideB:Int;
		
		p3x = slidex - CLIPRADIUS * nvx;
		p3y = slidey - CLIPRADIUS * nvy;
		
		p4x = p3x + slidedx;
		p4y = p3y + slidedy;
		
		sideA = pointOnSide(p3x, p3y);
		
		if (sideA == SIDE_BACK) return;
		
		sideB = pointOnSide(p4x, p4y);
		if (sideB == SIDE_ON || sideB == SIDE_FRONT) return;
		
		do {
			
			if (sideA == SIDE_ON) {
				frac = 0;
				break;
			}
			
			frac = crossFrac();
			
			if (frac >= blockfrac) return;
			
		} while (false);
		
		blockfrac = frac;
		blocknvx = -nvy;
		blocknvy = nvx;
		
	}
	
}