package hxdoom.lumps.audio;

import haxe.io.Bytes;
import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class SoundEffect extends LumpBase 
{
	public static var CONSTRUCTOR:(Array<Any>) -> SoundEffect = SoundEffect.new;
	
	public var sampleRate:Int;
	public var numSamples:Int;
	public var bytes:Bytes;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		sampleRate = _args[0];
		numSamples = _args[1];
		bytes = _args[2];
		
		trace(bytes.length);
	}
	
}