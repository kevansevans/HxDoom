package hxdoom.core;

import haxe.io.Bytes;
import haxe.crypto.Sha256;

import hxdoom.profile.*;

/**
 * ...
 * @author Kaelan
 */

class ProfileCore 
{
	
	public function new() 
	{
		
	}
	
	public function getNextMap(_currentMap:String):String {
		return "";
	}
	
	public static function getGameProfile():ProfileCore {
		
		return new UnknownGame();
		
	}
}