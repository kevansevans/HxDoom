package hxdoom.utils.math;

import haxe.Int32;
import haxe.Int64;
import hxdoom.Engine;

/**
 * ...
 * @author id Software, converted to Haxe by Kaelan
 * 
 * https://github.com/id-Software/DOOM/blob/77735c3ff0772609e9c8d29e3ce2ab42ff54d20b/linuxdoom-1.10/m_fixed.c
 */
abstract Fixed(Int32) from Int32 to Int32 from Int to Int {
    
	@:op(A * B) public inline static function mult(A:Fixed, B:Fixed):Fixed {
		var C:Int64 = Int64.ofInt(A);
		var D:Int64 = Int64.ofInt(B);
		return ((C * D) >> 16).low;
	}
	
	@:op(A / B) public inline static function div(A:Fixed, B:Fixed):Fixed {
		if (A >> 14 >= B) {
			return (A ^ B) < 0 ?  Engine.MININT : Engine.MAXINT;
		}
		else {
			var C:Float = ((0.0 + A) / (0.0 + B)) * Engine.FRACUNIT;
			if (C >= 2147483648.0 || C < -2147483648.0) throw "Div by zero";
			return Int64.fromFloat(C).low;
		}
	}
	
	//Haxe wouldn't allow me to compare two fixed numbers, so here they're
	//converted to traditional Haxe Ints and compared.
	//Will likely need to add Float support in the future.
	@:op(A < B) public inline static function lessthan(A:Fixed, B:Fixed):Bool {
		
		var C:Int = A;
		var D:Int = B;
		
		return C < D;
	}
	@:op(A <= B) public inline static function lessthaneq(A:Fixed, B:Fixed):Bool {
		var C:Int = A;
		var D:Int = B;
		
		return C <= D;
	}
	@:op(A > B) public inline static function greatthan(A:Fixed, B:Fixed):Bool {
		var C:Int = A;
		var D:Int = B;
		
		return C > D;
	}
	@:op(A >= B) public inline static function greatthaneq(A:Fixed, B:Fixed):Bool {
		var C:Int = A;
		var D:Int = B;
		
		return C >= D;
	}
	@:op(A >> B) public inline static function bitshiftright(A:Fixed, B:Fixed):Fixed {
		var C:Int = A;
		var D:Int = B;
		
		var E:Fixed = C >> D;
		return E;
	}
	@:op(A << B) public inline static function bitshiftleft(A:Fixed, B:Fixed):Fixed {
		var C:Int = A;
		var D:Int = B;
		
		var E:Fixed = C << D;
		return E;
	}
}