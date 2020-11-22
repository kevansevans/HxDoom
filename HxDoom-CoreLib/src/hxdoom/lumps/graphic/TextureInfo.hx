package hxdoom.lumps.graphic;

import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 * 
 * Not to be confused with Texture.hx, this is to handle the TEXTUREX lump format
 * 
 */
class TextureInfo extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> TextureInfo = TextureInfo.new;
	
	public var num_textures:Int;
	public var offsets:Array<Int>;
	public var textures:Map<String, TextureData>;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		if (override_new) return;
		
		num_textures = _args[0];
		offsets = _args[1];
		
		textures = new Map();
	}
	
	public function addTextureData(_texture:TextureData) {
		textures[_texture.textureName] = _texture;
	}
	
	public function toString():String {
		return([
			"Number of textures: {" + num_textures + "}",
			"List of offsets: {" + offsets + "}"
		].join(""));
	}
}

typedef TextureData = {
	var textureName:String;
	var width:Int;
	var height:Int;
	var numPatches:Int;
	var layout:Array<PatchLayout>;
}
typedef PatchLayout = {
	var offset_x:Int;
	var offset_y:Int;
	var patchIndex:Int;
}