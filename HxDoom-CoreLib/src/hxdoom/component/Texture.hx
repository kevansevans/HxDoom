package hxdoom.component;

import haxe.ds.Vector;
import hxdoom.lumps.graphic.Patch;

import hxdoom.typedefs.graphics.TextureData;
import hxdoom.typedefs.graphics.PatchLayout;
import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 */
class Texture extends Patch
{
	public static var CONSTRUCTOR:(Array<Any>) -> Texture = Texture.new;
	
	public var data:TextureData;
	
	public function new(_args:Array<Any>) 
	{
		super([]);
		
		if (override_new) return;
			
		data = _args[0];
		
		width = data.width;
		height = data.height;
		
		pixels = new Vector(width);
		for (w in 0...width) {
			pixels[w] = new Vector(height);
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
					
					if (posx < 0) posx += width;
					else if (posx >= width) posx -= width;
					if (posy < 0) posy += height;
					else if (posy >= height) posy -= height;
					
					if (pixels[posx] == null) {
						pixels[posx] = new Vector(height);
					}
					
					if (patch.pixels[w][h] == -1) continue;
					else pixels[posx][posy] = patch.pixels[w][h];
				}
			}
		}
	}
}