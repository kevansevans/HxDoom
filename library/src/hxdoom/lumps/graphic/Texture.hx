package hxdoom.lumps.graphic;

import haxe.ds.Vector;

import hxdoom.typedefs.graphics.TextureData;
import hxdoom.typedefs.graphics.PatchLayout;
import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 */
class Texture 
{
	public static var CONSTRUCTOR:(Array<Any>) -> Texture = Texture.new;
	
	public var data:TextureData;
	public var width:Int;
	public var height:Int;
	
	public var pixels:Array<Array<Int>>;
	
	public function new(_args:Array<Any>) 
	{
		data = _args[0];
		
		width = data.width;
		height = data.height;
		
		pixels = new Array();
		for (w in 0...width) {
			pixels[w] = new Array();
			for (h in 0...height) {
				pixels[w][h] = -1;
			}
		}
		
		for (num in 0...data.numPatches) {
			
			var patchNum = data.layout[num].patchIndex;
			var patch = Engine.TEXTURES.getPatch(Engine.TEXTURES.patches[patchNum]);
			
			for (w in 0...patch.width) {
				for (h in 0...patch.height) {
					var posx = w + data.layout[num].offset_x;
					var posy = h + data.layout[num].offset_y;
					
					if (posx >= width || posy >= height || posx < 0 || posy < 0) continue;
					
					pixels[posx][posy] = patch.pixels[w][h];
				}
			}
		}
	}
}