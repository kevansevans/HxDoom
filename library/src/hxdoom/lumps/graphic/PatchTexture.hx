package hxdoom.lumps.graphic;

import hxdoom.lumps.graphic.XTexture;


/**
 * ...
 * @author Kaelan
 */
class PatchTexture
{
	public static var CONSTRUCTOR:(Array<Any>) -> PatchTexture = PatchTexture.new;
	
	public var textureData:TextureData;
	
	public function new(_args:Array<Any>) 
	{
		textureData = _args[0];
	}
	
}