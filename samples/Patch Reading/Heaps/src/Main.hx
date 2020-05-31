import h2d.Tile;
import hl.Format.PixelFormat;
import h3d.mat.Data.TextureFormat;
import hxdoom.lumps.graphic.Patch;
import h3d.mat.Data.TextureFlags;
import hxd.BitmapData;
import hxd.PixelFormat;
import hxd.Pixels;
import h3d.mat.Texture;
import h2d.Bitmap;
import hxd.File;
import hxdoom.Engine;
class Main extends hxd.App
{
	var hxd:Engine;
	var baron_attack_a:PatchBitmap;
	var baron_attack_b:PatchBitmap;
	var baron_attack_c:PatchBitmap;

	var obj : h2d.Object;
	override function init()
	{
		hxd = new Engine();
		hxd.addWad(File.getBytes("assets/WAD/DOOM1.WAD"),"DOOM1.WAD");
		Engine.WADDATA.loadPlaypal();

		// creates a new object and put it at the center of the sceen
		obj = new h2d.Object(s2d);
		obj.x = Std.int(s2d.width / 2);
		obj.y = Std.int(s2d.height / 2);

		baron_attack_a = new PatchBitmap(Engine.WADDATA.getPatch("BOSSE1"));
		obj.addChild(baron_attack_a);
		baron_attack_a.x = baron_attack_a.y = 10;
		
		baron_attack_b = new PatchBitmap(Engine.WADDATA.getPatch("BOSSF1"));
		obj.addChild(baron_attack_b);
		baron_attack_b.x = baron_attack_a.x + baron_attack_a.width;
		baron_attack_b.y = 10;
		
		baron_attack_c = new PatchBitmap(Engine.WADDATA.getPatch("BOSSG1"));
		obj.addChild(baron_attack_c);
		baron_attack_c.x = baron_attack_b.x + baron_attack_b.width;
		baron_attack_c.y = 10;
	}
	static function main() {
		new Main();
	}
	override function onResize() 
	{
		if( obj == null ) return;
		// center our object
		obj.x = Std.int(s2d.width / 2);
		obj.y = Std.int(s2d.height / 2);
	}
}
class PatchBitmap extends Bitmap
{
	var pallete = Engine.WADDATA.playpal;
	public function new(patch:Patch)
	{
		var texture = new Texture(patch.width,patch.height,[TextureFlags.Target]);
		var pallete = Engine.WADDATA.playpal;
		var pixels = Pixels.alloc(patch.width,patch.height,PixelFormat.ARGB);
		for (x in 0...patch.width)
		{
			for (y in 0...patch.height)
			{
				var color = pallete.getColorHex(patch.pixels[x][y],0);
				pixels.setPixel(x,y,color);
			}
		}
		texture.uploadPixels(pixels);
		super(Tile.fromTexture(texture));
	}
}
