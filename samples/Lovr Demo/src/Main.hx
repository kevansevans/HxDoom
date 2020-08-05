package;

import hxdoom.Engine;
import hxdoom.lumps.graphic.Patch;
import lovr.Lovr;
import lovr.Filesystem;
import lovr.Graphics;
import lovr.Material;
import lovr.Texture;
import lovr.TextureData;
import lovr.TextureFormat;
import lovr.Data;

/**
 * ...
 * @author Kaelan
 * 
 * Dev note: As of Haxe 4.1.3, the -D lua_vanilla flag is not working correctly and will still generate required libs when compiling this project.
 * Once compiled, go into Main.lua and comment out whever "luv" is defined as a required lib. (typically around line 240 - 250 with this code)
 */
class Main 
{
	public static var hxdoom:Engine;
	public static var wadstring:String;
	
	public static var baron_a:Patch;
	public static var baron_b:Patch;
	public static var baron_c:Patch;
	
	public static var sprite_a:Texture;
	public static var sprite_b:Texture;
	public static var sprite_c:Texture;
	
	public static var spriteData_a:TextureData;
	public static var spriteData_b:TextureData;
	public static var spriteData_c:TextureData;
	
	public static var spriteMate_a:Material;
	public static var spriteMate_b:Material;
	public static var spriteMate_c:Material;
	
	static function main() {
		Lovr.load = function(args) {
			
			hxdoom = new Engine();
			wadstring = Filesystem.read("DOOM1.WAD", -1);
			hxdoom.addWadString(wadstring, "DOOM1.WAD");
			Engine.WADDATA.loadPlaypal();
			var palette = Engine.WADDATA.playpal;
			
			baron_a = Engine.WADDATA.getPatch("BOSSE1");
			spriteData_a = Data.newTextureData(baron_a.width, baron_a.height, TextureFormat.Rgba);
			for (w in 0...baron_a.width) for (h in 0...baron_a.height) {
				spriteData_a.setPixel(w, h, palette.getColorChannelFloat(baron_a.pixels[w][h], 0),
											palette.getColorChannelFloat(baron_a.pixels[w][h], 1), 
											palette.getColorChannelFloat(baron_a.pixels[w][h], 2), 
											palette.getColorChannelFloat(baron_a.pixels[w][h], 3));
			}
			sprite_a = Graphics.newTexture(spriteData_a);
			spriteMate_a = Graphics.newMaterial(sprite_a, 1, 1, 1, 1);
			
			baron_b = Engine.WADDATA.getPatch("BOSSF1");
			spriteData_b = Data.newTextureData(baron_b.width, baron_b.height, TextureFormat.Rgba);
			for (w in 0...baron_b.width) for (h in 0...baron_b.height) {
				spriteData_b.setPixel(w, h, palette.getColorChannelFloat(baron_b.pixels[w][h], 0),
											palette.getColorChannelFloat(baron_b.pixels[w][h], 1), 
											palette.getColorChannelFloat(baron_b.pixels[w][h], 2), 
											palette.getColorChannelFloat(baron_b.pixels[w][h], 3));
			}
			sprite_b = Graphics.newTexture(spriteData_b);
			spriteMate_b = Graphics.newMaterial(sprite_b, 1, 1, 1, 1);
			
			baron_c = Engine.WADDATA.getPatch("BOSSG1");
			spriteData_c = Data.newTextureData(baron_c.width, baron_c.height, TextureFormat.Rgba);
			for (w in 0...baron_c.width) for (h in 0...baron_c.height) {
				spriteData_c.setPixel(w, h, palette.getColorChannelFloat(baron_c.pixels[w][h], 0),
											palette.getColorChannelFloat(baron_c.pixels[w][h], 1), 
											palette.getColorChannelFloat(baron_c.pixels[w][h], 2), 
											palette.getColorChannelFloat(baron_c.pixels[w][h], 3));
			}
			sprite_c = Graphics.newTexture(spriteData_c);
			spriteMate_c = Graphics.newMaterial(sprite_c, 1, 1, 1, 1);
		}
		Lovr.draw = function() {
			Graphics.plane(spriteMate_a, -5, 0, -3, 2.5, 2.5);
			Graphics.plane(spriteMate_b, 0, 0, -3, 2.5, 2.5);
			Graphics.plane(spriteMate_c, 5, 0, -3, 2.5, 2.5);
		}
	}
}