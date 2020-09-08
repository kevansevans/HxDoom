package hxdoom.utils.math;

import haxe.Int32;
import haxe.Int64;
import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 */
abstract Fixed(Int32) from Int32 to Int32 from Int to Int {
    
	@:op(A * B) public inline static function mult(A:Fixed, B:Fixed):Fixed {
		var C:Int64 = Int64.ofInt(A);
		var D:Int64 = Int64.ofInt(B);
		return ((C * D) >> 16).low;
	}
	
	@:op(A / B) public inline static function div(A:Fixed, B:Fixed):Fixed {
		if (A >> 14 >= B >> 0) {
			return (A ^ B) < 0 ?  Engine.MININT : Engine.MAXINT;
		}
		else {
			var C:Float = ((0.0 + A) / (0.0 + B)) * Engine.FRACUNIT;
			if (C >= 2147483648.0 || C < -2147483648.0) throw "Div by zero";
			return Int64.fromFloat(C).low;
		}
	}
}