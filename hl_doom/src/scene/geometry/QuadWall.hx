package scene.geometry;

import h3d.mat.Material;
import h3d.mat.Texture;
import h3d.prim.Quads;
import h3d.col.Point;
import haxe.ds.Map;
import hxd.Pixels;
import hxdoom.enums.eng.SideType;
import hxdoom.lumps.map.Segment;
import hxdoom.Engine;
import hxdoom.enums.eng.ColorMode;
import hxd.PixelFormat;
import h3d.mat.Data.TextureFlags;
import h3d.mat.Data.Wrap;
import h3d.prim.UV;
import h3d.mat.Data.Filter;
import h3d.mat.Pass;
import h3d.mat.Data.Blend;
import h3d.mat.Data.Face;
import h3d.mat.BlendMode;
import hxdoom.lumps.map.Vertex;

/**
 * ...
 * @author Kaelan
 */
class QuadWall extends Quads
{
	public static var MatMap:Map<String, Material> = new Map();
	
	public var segment:Segment;
	public var material:Material;
	public var texturename:String = "-";
	public function new(_seg:Segment, _type:SideType) 
	{
		
		segment = _seg;
		
		var line = segment.lineDef;
		
		switch(_type) {
			case SOLID :
				
					
				super([	new Point(line.start.xpos * -1, line.start.ypos, segment.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.end.ypos, segment.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.start.ypos, segment.sector.floorHeight),
						new Point(line.end.xpos * -1, line.end.ypos, segment.sector.floorHeight)	]);
						
				texturename = line.frontSideDef.middle_texture;
				
			case FRONT_TOP :
				
				super([	new Point(line.start.xpos * -1, line.start.ypos, line.frontSideDef.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.frontSideDef.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.ceilingHeight)	]);
							
				texturename = line.frontSideDef.upper_texture;
				
			case FRONT_MIDDLE :
					
				super([	new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.floorHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.floorHeight)	]);
							
				texturename = line.frontSideDef.middle_texture;
				
			case FRONT_BOTTOM :
				
				super([	new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.floorHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.floorHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.frontSideDef.sector.floorHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.frontSideDef.sector.floorHeight)	]);
							
				texturename = line.frontSideDef.lower_texture;
				
			case BACK_TOP :
				
				super([	new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.frontSideDef.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.frontSideDef.sector.ceilingHeight)	]);
							
				texturename = line.backSideDef.upper_texture;
				
			case BACK_MIDDLE :
				
				super([	new Point(line.start.xpos * -1, line.end.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.start.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.end.ypos, line.backSideDef.sector.floorHeight),
						new Point(line.end.xpos * -1, line.start.ypos, line.backSideDef.sector.floorHeight)	]);
							
				texturename = line.backSideDef.middle_texture;
				
			case BACK_BOTTOM :
					
				super([	new Point(line.end.xpos * -1, line.end.ypos, line.frontSideDef.sector.floorHeight),
							new Point(line.start.xpos * -1, line.start.ypos, line.frontSideDef.sector.floorHeight),
							new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.floorHeight),
							new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.floorHeight)	]);
							
				texturename = line.backSideDef.lower_texture;
				
		}
		
		var d_texture = Engine.TEXTURES.getTexture(texturename);
		var palette = Engine.TEXTURES.playpal;
		
		var pix_ratio_x = 1 / d_texture.width;
		var pix_ratio_y = 1 / d_texture.height;
		
		var offset_x:Float;
		var offset_y:Float;
		
		switch (_type) {
			case SOLID | FRONT_TOP | FRONT_MIDDLE | FRONT_BOTTOM :
				offset_x = line.frontSideDef.xoffset * pix_ratio_x;
				offset_y = line.frontSideDef.yoffset * pix_ratio_y;
				
			case BACK_TOP | BACK_MIDDLE | BACK_BOTTOM :
				offset_x = line.backSideDef.xoffset * pix_ratio_x;
				offset_y = (line.backSideDef.yoffset * pix_ratio_y) - pix_ratio_y;
		}
		
		var width_ratio = Vertex.distance(line.end, line.start) * pix_ratio_x;
		var height_ratio = 0.0;
		
		switch (_type) {
			case SOLID | FRONT_MIDDLE :
				height_ratio = (line.frontSideDef.sector.ceilingHeight - line.frontSideDef.sector.floorHeight) * pix_ratio_y;
			case FRONT_BOTTOM :
				height_ratio = (line.backSideDef.sector.floorHeight - line.frontSideDef.sector.floorHeight) * pix_ratio_y;
			case FRONT_TOP :
				height_ratio = (line.frontSideDef.sector.ceilingHeight - line.backSideDef.sector.ceilingHeight) * pix_ratio_y;
			case BACK_MIDDLE :
				height_ratio = (line.backSideDef.sector.ceilingHeight - line.backSideDef.sector.floorHeight) * pix_ratio_y;
			case BACK_BOTTOM :
				height_ratio = (line.frontSideDef.sector.floorHeight - line.backSideDef.sector.floorHeight) * pix_ratio_y;
			case BACK_TOP :
				height_ratio = (line.backSideDef.sector.ceilingHeight - line.frontSideDef.sector.ceilingHeight) * pix_ratio_y;
			default :
		}
		
		this.addNormals();
		
		this.uvs = [new UV(offset_x, offset_y + height_ratio), 
					new UV(offset_x + width_ratio, offset_y + height_ratio),
					new UV(offset_x, offset_y),
					new UV(offset_x + width_ratio, offset_y)];
		
		if (MatMap[texturename] != null) {
			material = MatMap[texturename];
		} else {
			
			var pixels = Pixels.alloc(d_texture.width, d_texture.height, PixelFormat.ARGB);
			for (x in 0...d_texture.width) for (y in 0...d_texture.height) {
				var color = palette.getColorHex(d_texture.pixels[x][(d_texture.height - 1) - y], ColorMode.ARGB);
				pixels.setPixel(x, y, color);
			}
			
			var texture = new Texture(d_texture.width, d_texture.height, [TextureFlags.Target]);
			texture.uploadPixels(pixels);
			texture.wrap = Wrap.Repeat;
			texture.filter = Filter.Nearest;
			material = Material.create(texture);
			switch (_type) {
				case BACK_MIDDLE | FRONT_MIDDLE :
					material.blendMode = BlendMode.Alpha;
				default :
					
			}
			MatMap[texturename] = material;
		}
	}
	
}