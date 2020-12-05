package hxdoom.lumps;

import haxe.io.Bytes;

/**
 * ...
 * @author Kaelan
 */
class LumpBase 
{

	public var validcount:Int;
	public var override_new:Bool = false;
	public var lumpID:Int;
	
	public function new() 
	{
		
	}
	
	public function toDataBytes():Bytes
	{
		return Bytes.ofString("NO BYTES DEFINED - FIX ME");
	}
	public function toStringBytes()
	{
		
	}
	public function toJSON()
	{
		
	}
	public function toZDoomStringDef():String {
		/*
		 * This function will typically serve as a method to return a lump as a modern ZDoom
		 * compatible string of text. These do not follow any consistent behavior between asset
		 * types, but typically these are always strings
		 */
		
		return ("NO ZDOOM DEF DEFINED - FIX ME");
	}
}