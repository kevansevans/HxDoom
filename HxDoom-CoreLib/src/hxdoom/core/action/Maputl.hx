package hxdoom.core.action;

import hxdoom.Engine;
import hxdoom.lumps.map.LineDef;

/**
 * ...
 * @author Kaelan
 * 
 * from https://github.com/Olde-Skuul/doom3do/blob/5713f6fd2a66338e0135d41e297de963652371af/source/maputl.c
 */
class Maputl 
{

	public static var getApproxDistance:(Float, Float) -> Float = getApproxDistanceDefault;
	public static function getApproxDistanceDefault(_dx:Float, _dy:Float):Float
	{
		var dx = _dx;
		var dy = _dy;
		if (dx < 0) dx = -dx;
		if (dy < 0) dy = -dy;
		if (dx < dy) dx /= 2;
		else dy /= 2;
		dx += dy;
		return dx;
	}
	
	public static var blockLinesIterator:(Int, Int, (LineDef -> Bool)) -> Bool = blockLinesIteratorDefault;
	public static function blockLinesIteratorDefault(_x:Int, _y:Int, _checkLine:LineDef -> Bool):Bool
	{
		if (_x < Engine.LEVELS.blockmap.width && _y < Engine.LEVELS.blockmap.height) {
			
			var y = _y * Engine.LEVELS.blockmap.width;
			y += _x;
			
			var lines = Engine.LEVELS.blockmap.blocks[y];
			for (line in lines) {
				if (!_checkLine(line)) {
					return false;
				}
			}
			
		}
		
		return true;
	}
	
}