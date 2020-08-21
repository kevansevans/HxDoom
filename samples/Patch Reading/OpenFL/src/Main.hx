package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.Assets;

import hxdoom.Engine;
import hxdoom.lumps.graphic.Patch;
import hxdoom.enums.eng.ColorMode;

/**
 * ...
 * @author Kaelan
 * 
 * "Patches" are the more barebones graphic assets that id Tech 1 uses.
 * These are sometimes used to assemble larger textures. This technique
 * helps save space on duplicate data.
 * 
 */
class Main extends Sprite 
{
	var hxd:Engine;
	
	var baron_attack_a:PatchBitmap;
	var baron_attack_b:PatchBitmap;
	var baron_attack_c:PatchBitmap;
	
	public function new() 
	{
		super();
		
		hxd = new Engine();
		hxd.addWadBytes(Assets.getBytes("wad/DOOM1.WAD"), "DOOM1.WAD");
		Engine.TEXTURES.loadPlaypal();
		
		/*
		 * Engine.TEXTURES.getPatch() expects a string and returns a hxdoom.lump.graphic.Patch
		 * Here we use openFL to convert a Patch into a Bitmap.
		 * HxDoom is not an OpenFL exclusive library.
		 */
		
		baron_attack_a = new PatchBitmap(Engine.TEXTURES.getPatch("BOSSE1"));
		addChild(baron_attack_a);
		baron_attack_a.x = baron_attack_a.y = 10;
		
		baron_attack_b = new PatchBitmap(Engine.TEXTURES.getPatch("BOSSF1"));
		addChild(baron_attack_b);
		baron_attack_b.x = baron_attack_a.x + baron_attack_a.width;
		baron_attack_b.y = 10;
		
		baron_attack_c = new PatchBitmap(Engine.TEXTURES.getPatch("BOSSG1"));
		addChild(baron_attack_c);
		baron_attack_c.x = baron_attack_b.x + baron_attack_b.width;
		baron_attack_c.y = 10;
	}

}

class PatchBitmap extends Bitmap
{
	var patch:Patch;
	var pallete = Engine.TEXTURES.playpal;
	
	public function new(_patch:Patch) {
		
		patch = _patch;
		
		var data:BitmapData = new BitmapData(patch.width, patch.height, true);
		
		/*
		 * Pixel data is stored in a 2D vector. These are not ARGB colors of any sort.
		 * patch.pixels[width][height] will contain a palette (Playpal) index.
		 * using pallete.getColorHex(index, 0) will return an ARGB value.
		 * The only time a patch will return any alpha value other than 0xFF is when
		 * the patch has full transparency. Analog transparency is not a supported feature.
		 */
		
		for (width in 0...patch.width) for (height in 0...patch.height) {
			
			var color = pallete.getColorHex(patch.pixels[width][height], ColorMode.ARGB);
			data.setPixel32(width, height, color);
		}
		
		super(data);
	}
}
