package hxdoom.core;

import haxe.io.Bytes;
import haxe.crypto.Sha256;

import hxdoom.profile.*;

/**
 * ...
 * @author Kaelan
 */
enum abstract WadSha256(String) from String {
	var DOOM_SHAREWARE:String = "}C࿐g٧䕠๳✻󱵨Yr�ˇq";
}
class ProfileCore 
{
	var contains:Array<String>;
	public function new() 
	{
		
	}
	
	public function getNextMap(_currentMap:String):String {
		return "";
	}
	
	public static function getWadProfile(_bytes:Bytes):Dynamic {
		
		var str256:String = Sha256.make(_bytes).toString();
		
		switch (str256) {
			case WadSha256.DOOM_SHAREWARE :
				return new DoomShareware();
			default :
				return new UnknownGame();
		}
	}
	
}