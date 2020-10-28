package hxdoom.lumps.graphic;

import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class Flat extends LumpBase 
{
	public static var CONSTRUCTOR:(Array<Any>) -> Flat = Flat.new;
	
	public var pixels:Array<Int>;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		pixels = _args[0];
	}
	
}