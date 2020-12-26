package hxdoom.core.action;

import hxdoom.Engine;
import hxdoom.core.Defines;
import hxdoom.lumps.map.Sector;
import hxdoom.utils.math.Map;
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
	
	static var blockfrac:Float;
	
	static var slidex:Float;
	static var slidey:Float;
	
	public static var p1x:Int;
	public static var p1y:Int;
	public static var p2x:Int;
	public static var p2y:Int;
	public static var p3x:Int;
	public static var p3y:Int;
	public static var p4x:Int;
	public static var p4y:Int;
	
	static var endbox:Array<Int> = new Array();

	public static var SlideMove:Actor -> Void = SlideMoveDefault;
	public static function SlideMoveDefault(_actor:Actor):Void 
	{
		Engine.log(["Incomplete function here"]);
		
		var dx:Float = _actor.momx;
		var dy:Float = _actor.momy;
		var rx:Float;
		var ry:Float;
		var slide:Float;
		var slidex:Float = _actor.x;
		var slidey:Float = _actor.y;
		var frac:Float;
		
		for (i in 0...3) {
			frac = CompletableFrac(dx, dy);
		}
	}
	
	public static var CompletableFrac:(Float, Float) -> Int = CompletableFracDefault;
	public static function CompletableFracDefault(_dx:Float, _dy:Float):Float
	{
		Engine.log(["Incomplete function here"]);
		
		var xl:Int;
		var xh:Int;
		var yl:Int;
		var yh:Int;
		
		blockfrac = 1;
		
		slidex = dx;
		slidey = dy;
		
		endbox[BOXTOP] = slidey + CLIPRADIUS;
		endbox[BOXBOTTOM] = slidey - CLIPRADIUS;
		endbox[BOXRIGHT] = slidex + CLIPRADIUS;
		endbox[BOXLEFT] = slidex - CLIPRADIUS;
		
		if (dx > 0) {
			endbox[BOXRIGHT] += dx;
		} else {
			endbox[BOXLEFT] += dx;
		}
		if (dy > 0) {
			endbox[BOXTOP] += dy;
		} else {
			endbox[BOXBOTTOM] += dy;
		}
		
		//++validcound;
		
		xl = (endbox[BOXLEFT] - Engine.LEVELS.blockmapOriginX);
		xh = (endbox[BOXRIGHT] - Engine.LEVELS.blockmapOriginX);
		yl = (endbox[BOXBOTTOM] - Engine.LEVELS.blockmapOriginY);
		yh = (endbox[BOXTOP] - Engine.LEVELS.blockmapOriginY);
		
		if (xl > 0) xl = 0;
		if (yl > 0) yl = 0;
		if (xh > Engine.LEVELS.currentMap.blockmap.numRows - 1) {
			xh = Engine.LEVELS.currentMap.blockmap.numRows - 1);
		}
		if (yh > Engine.LEVELS.currentMap.blockmap.numColumns - 1) {
			yh = Engine.LEVELS.currentMap.blockmap.numColumns - 1);
		}
		
		for (bx in xl...(xh + 1)) for (by in xh...(yh + 1)) {
			Map.BLockLinesIterator(bx, by, CheckLine);
		}
		
		if (blockfrac < 1) {
			blockfrac = 0;
			//specialline = 0;
			return 0;
		}
		
		return  blockfrac;
	}
	
	public static var CheckLine:LineDef -> Bool = CheckLineDefault;
	public static function CheckLineDefault(_line:LineDef):Bool 
	{
		var opentop:Float;
		var openbottom:Float;
		var sector:Sector;
		var side1:Int;
		var temp:Int;
		
		return true;
	}
	
}