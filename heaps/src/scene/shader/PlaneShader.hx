package scene.shader;

import hxd.Pixels;
import hxsl.Shader;
import hxsl.Types.Sampler2D;
import hxd.PixelFormat;
import hxsl.Types.Vec;
import h3d.mat.Data.Filter;
import h3d.mat.Data.Wrap;

import hxdoom.lumps.graphic.Flat;
import hxdoom.lumps.graphic.Playpal;
import hxdoom.enums.eng.ColorChannel;

/**
 * ...
 * @author Kaelan
 */
class PlaneShader extends Shader 
{

	public static var SRC = {
		
		@:import h3d.shader.Texture;
		
		@global var global : {
			var time : Float;
		};
		
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
			
			var swatch:Int = int(texture.get(uvOffset).r * 255);
			
			pixelColor = palette[swatch];
			if (texture.get(calculatedUV).g == 0) discard;
			
		}
		
	}
	
	public function new(_playpal:Playpal, _flat:Flat) 
	{
		super();
		
		setPalette(_playpal);
		
		setFlat(_flat);
		
		setSheet();
	}
	
	public function setFlat(_flat:Flat) 
	{
		var work:Sampler2D = new Sampler2D(64, 64, null, PixelFormat.RGBA);
		var pixels:Pixels = Pixels.alloc(64, 64, PixelFormat.RGBA);
		
		var index:Int = 0;
		for (x in 0...64) {
			for (y in 0...64) {
				var swatch = _flat.pixels[index];
				pixels.setPixel(63 - y, 63 - x, 0xFF << 24 | swatch << 16 | 0xFF << 8 | 0);
				++index;
			}
		}
		
		work.uploadPixels(pixels);
		work.wrap = Wrap.Repeat;
		work.filter = Filter.Nearest;
		
		this.texture = work;
	}
	
	public function setSheet(_sheet:Int = 0) {
		this.palette = sheets[_sheet];
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
	
}