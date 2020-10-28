package hxdoom.enums;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.Tools;

#end

/**
 * ...
 * @author Kaelan
 */

class EnumTool
{
	//https://code.haxe.org/category/macros/enum-abstract-values.html
	public static macro function toStringArray(typePath:Expr):Expr {
		var type = Context.getType(typePath.toString());
		switch (type.follow()) {
			case TAbstract(_.get() => ab, _) if (ab.meta.has(":enum")):
				var valueExprs = [];
				for (field in ab.impl.get().statics.get()) {
					if (field.meta.has(":enum") && field.meta.has(":impl")) {
						var fieldName = field.name;
						valueExprs.push(macro $typePath.$fieldName);
					}
				}
				return macro $a{valueExprs};
			default:
				throw new Error(type.toString() + " should be @:enum abstract", typePath.pos);
		}
	}
}