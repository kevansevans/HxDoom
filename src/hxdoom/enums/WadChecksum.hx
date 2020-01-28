package hxdoom.enums;

import haxe.macro.Context;
import haxe.macro.Expr.Field;
import sys.FileSystem;
import haxe.crypto.Sha256;

import lime.utils.Assets;
import haxe.Json;

/**
 * @author Kaelan
 */

@:build(WadChecksumbuilder.buildWadEnum())
enum abstract WadChecksum(String) from String 
{
}

@:noCompletion class WadChecksumbuilder() {
	public static macro function buildWadEnum():Array<Field> {
		if (Assets.
	}
}