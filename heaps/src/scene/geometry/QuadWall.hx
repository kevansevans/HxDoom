package scene.geometry;

import haxe.ds.Map;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Sector;

import hxd.Res;
import h3d.mat.Material;
import h3d.mat.PbrMaterial;
import h3d.prim.Quads;
import h3d.col.Point;
import h3d.prim.UV;
import h3d.mat.Data.Face;

import hxdoom.enums.eng.SideType;
import hxdoom.lumps.graphic.Playpal;
import hxdoom.lumps.map.Segment;
import hxdoom.lumps.map.Vertex;
import hxdoom.Engine;

import scene.shader.PaletteShader;

/**
 * ...
 * @author Kaelan
 */
class QuadWall extends Quads
{
	public var segment:Segment;
	public var material:Material;
	public var texturename:String = "-";
	
	public var palette:Playpal = Engine.TEXTURES.playpal;
	public var lumpTexture:hxdoom.component.Texture;
	public var assetShader:PaletteShader;
	
	public var type:SideType;
	
	public function new(_seg:Segment, _type:SideType) 
	{
		
		segment = _seg;
		
		type = _type;
		
		var line = segment.lineDef;
		
		switch(_type) {
			case SOLID :
				
					
				super([	new Point(line.start.xpos * -1, line.start.ypos, segment.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.end.ypos, segment.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.start.ypos, segment.sector.floorHeight),
						new Point(line.end.xpos * -1, line.end.ypos, segment.sector.floorHeight)
					]);
						
				texturename = line.frontSideDef.middle_texture;
				
			case FRONT_TOP :
				
				super([	new Point(line.start.xpos * -1, line.start.ypos, line.frontSideDef.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.frontSideDef.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.ceilingHeight)
					]);
							
				texturename = line.frontSideDef.upper_texture;
				
			case FRONT_MIDDLE :
				
				super([	new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.floorHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.floorHeight)
					]);
							
				texturename = line.frontSideDef.middle_texture;
				
			case FRONT_BOTTOM :
				
				super([	new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.floorHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.floorHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.frontSideDef.sector.floorHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.frontSideDef.sector.floorHeight)
					]);
							
				texturename = line.frontSideDef.lower_texture;
				
			case BACK_TOP :
				
				super([	new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.frontSideDef.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.frontSideDef.sector.ceilingHeight)
					]);
							
				texturename = line.backSideDef.upper_texture;
				
			case BACK_MIDDLE :
				
				super([	new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.ceilingHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.floorHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.floorHeight)	
					]);
							
				texturename = line.backSideDef.middle_texture;
				
			case BACK_BOTTOM :
					
				super([	new Point(line.end.xpos * -1, line.end.ypos, line.frontSideDef.sector.floorHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.frontSideDef.sector.floorHeight),
						new Point(line.end.xpos * -1, line.end.ypos, line.backSideDef.sector.floorHeight),
						new Point(line.start.xpos * -1, line.start.ypos, line.backSideDef.sector.floorHeight)	
					]);
							
				texturename = line.backSideDef.lower_texture;
				
		}
		
		lumpTexture = Engine.TEXTURES.getTexture(texturename);
		
		var pix_ratio_x = 1 / lumpTexture.width;
		var pix_ratio_y = 1 / lumpTexture.height;
		
		var offset_x:Float;
		var offset_y:Float;
		
		switch (_type) {
			case SOLID | FRONT_TOP | FRONT_MIDDLE | FRONT_BOTTOM :
				offset_x = line.frontSideDef.xoffset;
				offset_y = line.frontSideDef.yoffset;
				
			case BACK_TOP | BACK_MIDDLE | BACK_BOTTOM :
				offset_x = line.backSideDef.xoffset;
				offset_y = line.backSideDef.yoffset;
		}
		
		var width_ratio = (Vertex.distance(line.end, line.start) * pix_ratio_x) + (pix_ratio_x * offset_x);
		var height_ratio = 0.0;
		
		switch (_type) {
			case SOLID :
				height_ratio = (line.frontSideDef.sector.ceilingHeight - line.frontSideDef.sector.floorHeight) * pix_ratio_y + (pix_ratio_y * offset_y);
			case FRONT_BOTTOM :
				height_ratio = (line.backSideDef.sector.floorHeight - line.frontSideDef.sector.floorHeight) * pix_ratio_y + (pix_ratio_y * offset_y);
			case FRONT_MIDDLE :
				height_ratio = (line.backSideDef.sector.ceilingHeight - line.backSideDef.sector.floorHeight) * pix_ratio_y + (pix_ratio_y * offset_y);
			case FRONT_TOP :
				height_ratio = (line.frontSideDef.sector.ceilingHeight - line.backSideDef.sector.ceilingHeight) * pix_ratio_y + (pix_ratio_y * offset_y);
			case BACK_MIDDLE :
				height_ratio = (line.backSideDef.sector.ceilingHeight - line.backSideDef.sector.floorHeight) * pix_ratio_y + (pix_ratio_y * offset_y);
			case BACK_BOTTOM :
				height_ratio = (line.frontSideDef.sector.floorHeight - line.backSideDef.sector.floorHeight) * pix_ratio_y + (pix_ratio_y * offset_y);
			case BACK_TOP :
				height_ratio = (line.backSideDef.sector.ceilingHeight - line.frontSideDef.sector.ceilingHeight) * pix_ratio_y + (pix_ratio_y * offset_y);
			default :
		}
		
		this.addNormals();
		
		this.uvs = [new UV(0, height_ratio), 
					new UV(width_ratio, height_ratio),
					new UV(0, 0),
					new UV(width_ratio, 0)];
		
		material = Material.create();
		
		assetShader = new PaletteShader(palette, lumpTexture);
		material.mainPass.addShader(assetShader);
		
		material.mainPass.setPassName("alpha");
		
		MapScene.MatMap[texturename] = material;
	}
	
	public function updateTexture(_asset:hxdoom.component.Texture) {
		assetShader.setTexture(_asset);
	}
	
	public function updatePalette(_playpal:Playpal) {
		assetShader.setPalette(_playpal);
	}
	
	public function updateGeneral() {
		
	}
	
	//This is only called if the line *might* be visible, but check for other conditions that might make it impossible to be visible.
	public function checkVisibility():Bool {
		
		var line:LineDef = segment.lineDef;
		var frontSector:Sector = segment.lineDef.frontSideDef.sector;
		var backSector:Sector = segment.lineDef.backSideDef == null ? null : segment.lineDef.backSideDef.sector;
		
		switch (this.type) {
			case SOLID | FRONT_MIDDLE  :
				if (frontSector.floorHeight >= frontSector.ceilingHeight) return false;
			case FRONT_TOP :
				if (frontSector.ceilingHeight <= backSector.ceilingHeight) return false;
			case FRONT_BOTTOM :
				if (frontSector.floorHeight >= backSector.floorHeight) return false;
			case BACK_TOP :
				if (frontSector.ceilingHeight >= backSector.ceilingHeight) return false;
			case BACK_MIDDLE :
				if (backSector.floorHeight >= backSector.ceilingHeight) return false;
			case BACK_BOTTOM :
				if (frontSector.floorHeight <= backSector.floorHeight) return false;
			default :
		}
		
		return true;
	}
	
}