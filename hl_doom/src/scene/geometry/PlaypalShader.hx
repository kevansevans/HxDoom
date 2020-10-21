package scene.geometry;

import hxdoom.lumps.graphic.Patch;
import hxdoom.lumps.graphic.Playpal;
import hxsl.Shader;
import hxd.Pixels;
import hxd.PixelFormat;
import h3d.mat.Data.Filter;

import hxsl.Types.Vec;
import hxsl.Types.Sampler2D;
import hxsl.Types.Sampler2DArray;
import hxdoom.enums.eng.ColorMode;
import h3d.mat.Data.TextureFlags;
import hxdoom.enums.eng.ColorChannel;
import h3d.mat.Data.Wrap;

/**
 * ...
 * @author Kaelan
 */
class PlaypalShader extends Shader 
{

	static var SRC = {
		
		@:import h3d.shader.Texture;
		
		@param @const var NumSwatches:Int;
		@param var palette:Array<Vec4, 255>;
		@param var texture:Sampler2D;
		@param var activeSheet:Int;
		
		function vertex() {
			calculatedUV = input.uv;
		}
		
		function fragment() {
			
			pixelColor = palette[int(texture.get(calculatedUV).r * 255)];
			
		}
		
    };
	
	public function new(_playpal:Playpal, _asset:hxdoom.component.Texture ) {
		
		super();
		
		this.NumSwatches = 255;
		
		var pal:Sampler2D = new Sampler2D(16, 16, null, PixelFormat.RGBA);
		var swatches:Array<Vec> = new Array();
			
		for (pal in 0..._playpal.palettes.length) {
			for (sw in 0..._playpal.palettes[pal].length) {
				
				var color:Vec = new Vec();
				
				color.a = 0xFF;
				color.r = _playpal.getColorChannelFloat(sw, ColorChannel.RED);
				color.g = _playpal.getColorChannelFloat(sw, ColorChannel.GREEN);
				color.b = _playpal.getColorChannelFloat(sw, ColorChannel.BLUE);
				
				swatches.push(color);
			}
		}
		
		this.palette = swatches;
		
		var work_text:Sampler2D = new Sampler2D(_asset.width, _asset.height, null, PixelFormat.RGBA);
		var tex_pixels:Pixels = Pixels.alloc(_asset.width, _asset.height, PixelFormat.RGBA);
		
		for (x in 0..._asset.width) for (y in 0..._asset.height) {
			
			var swatch = _asset.pixels[x][(_asset.height - 1) - y];
			
			if (swatch == -1) {
				tex_pixels.setPixel(x, y, 0x00 << 24 | swatch << 16 | swatch << 8 | swatch);
			} else {
				tex_pixels.setPixel(x, y, 0xFF << 24 | swatch << 16 | swatch << 8 | swatch);
			}
			
		}
		
		work_text.uploadPixels(tex_pixels);
		work_text.filter = Filter.Nearest;
		work_text.wrap = Wrap.Repeat;
		this.texture = work_text;
		
		this.activeSheet = 1;
		
	}
	
}