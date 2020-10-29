package hxdoom.lumps.graphic;

import haxe.ds.Vector;
import hxdoom.lumps.graphic.Patch;

/**
 * ...
 * @author Kaelan
 */
class Flat extends Patch
{
	public static var CONSTRUCTOR:(Array<Any>) -> Flat = Flat.new;
	
	public function new(_args:Array<Any>) 
	{
		super([64, 64, 0, 0]);
		
		pixels = new Vector(64);
	}
	
}