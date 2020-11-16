package scene.shader;

import hxdoom.lumps.graphic.Patch;
import hxdoom.lumps.graphic.Playpal;
import hxsl.Shader;
import hxd.Pixels;
import hxd.PixelFormat;
import h3d.mat.Data.Filter;

import hxsl.Types.Vec;
import hxsl.Types.Sampler2D;
import hxdoom.enums.eng.ColorChannel;
import h3d.mat.Data.Wrap;

/**
 * ...
 * @author Kaelan
 */
class PaletteShader extends Shader 
{

	static var SRC = {
		
		@:import h3d.shader.Texture;
		
		@global var global : {
			var time : Float;
		};
		
		@param var index:Int = 0;
		
		@param var palette:Array<Vec4, 255>;
		@param var texture:Sampler2D;
		
		@param var width:Int;
		@param var height:Int;
		@param var scrollX:Int = 8;
		@param var scrollY:Int = 0;
		
		function vertex() {
			calculatedUV = input.uv;
		}
		
		function fragment() {
			
			var uvOffset:Vec2 = calculatedUV;
			
			if (texture.get(uvOffset).g == 0) {
				discard;
				return;
			}
			
			var swatch:Int = int(texture.get(uvOffset).r * 255);
			pixelColor = palette[swatch];
			
		}
		
    };
	
	public function new(_playpal:Playpal, _asset:Patch) {
		
		super();
		
		setPalette(_playpal);
		
		setTexture(_asset);
		
		setSheet();
		
	}
	
	public var sheets:Array<Array<Vec>>;
	
	public function setPalette(_playpal:Playpal) {
		
		sheets = new Array();
			
		for (pal in 0..._playpal.palettes.length) {
			
			var swatches:Array<Vec> = new Array();
			
			for (swatch in 0..._playpal.palettes[pal].length) {
				
				var color:Vec = new Vec();
				
				color.a = 0xFF;
				color.r = _playpal.getColorChannelFloat(swatch, ColorChannel.RED, pal);
				color.g = _playpal.getColorChannelFloat(swatch, ColorChannel.GREEN, pal);
				color.b = _playpal.getColorChannelFloat(swatch, ColorChannel.BLUE, pal);
				
				swatches.push(color);
			}
			
			sheets[pal] = swatches;
		}
	}
	
	public function setSheet(_sheet:Int = 0) {
		this.palette = sheets[_sheet];
	}
	
	public function setTexture(_asset:Patch) {
		
		var work_text:Sampler2D = new Sampler2D(_asset.width, _asset.height, null, PixelFormat.RGBA);
		var tex_pixels:Pixels = Pixels.alloc(_asset.width, _asset.height, PixelFormat.RGBA);
		
		for (x in 0..._asset.width) for (y in 0..._asset.height) {
			
			var swatch = _asset.pixels[x][(_asset.height - 1) - y];
			
			if (swatch == -1) {
				tex_pixels.setPixel(x, y, 0x00 << 24 | swatch << 16 | 0 << 8 | 0);
			} else {
				tex_pixels.setPixel(x, y, 0xFF << 24 | swatch << 16 | 0xFF << 8 | 0);
			}
			
		}
		
		work_text.uploadPixels(tex_pixels);
		work_text.filter = Filter.Nearest;
		work_text.wrap = Wrap.Repeat;
		
		this.texture = work_text;
		this.height = work_text.height;
		this.width = work_text.width;
	}
	
}