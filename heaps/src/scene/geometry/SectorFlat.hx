package scene.geometry;

import h3d.prim.Polygon;
import h3d.col.Point;
import h3d.mat.Material;

import hxdoom.Engine;
import hxdoom.core.Reader;
import hxdoom.enums.eng.PlaneType;
import hxdoom.lumps.graphic.Flat;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Sector;
import hxdoom.lumps.map.Vertex;

import scene.shader.PlaneShader;

/**
 * ...
 * @author Kaelan
 */
class SectorFlat extends Polygon
{
	var sector:Sector;
	var verts:Array<Vertex>;
	var lumpTexture:Flat;
	public var material:Material;
	var assetShader:PlaneShader;
	
	public function new(_sector:Sector, _plane:PlaneType) 
	{
		
		var textureName:String = "-";
		
		verts = new Array();
		verts.push(_sector.lines[0].start);
		verts.push(_sector.lines[_sector.lines.length - 1].end);
		var worklines:Array<LineDef> = _sector.lines;
		
		for (line in worklines) {
			if (verts.indexOf(line.start) == -1 && verts.indexOf(line.end) == -1) {
				
				verts.push(line.start);
				verts.push(line.end);
				
			} else if (verts.indexOf(line.start) != -1 && verts.indexOf(line.end) == -1) {
				
				verts.insert(verts.indexOf(line.start) + 1, line.end);
				
			} else if (verts.indexOf(line.start) == -1 && verts.indexOf(line.end) != -1) {
				
				if (verts.indexOf(line.end) == 0) verts.unshift(line.start);
				else verts.insert(verts.indexOf(line.end) - 1, line.start);
				
			} else if (verts.indexOf(line.start) != -1 && verts.indexOf(line.end) != -1) {
				//sort the lines as we go
				if (verts.indexOf(line.start) < verts.indexOf(line.end)) {
					var a = verts.indexOf(line.start);
					var b = verts.indexOf(line.end);
					verts.remove(line.start);
					verts.remove(line.end);
					verts.insert(a, line.end);
					verts.insert(b, line.start);
				}
			}
		}
		
		var points:Array<Point> = new Array();
		
		var planeHeight:Int = 0;
		switch (_plane) {
			case PlaneType.FALSE | PlaneType.FLOOR :
				planeHeight = _sector.floorHeight;
				textureName = _sector.floorTexture;
			case PlaneType.CEILING :
				planeHeight = _sector.ceilingHeight;
				textureName = _sector.ceilingTexture;
		}
		
		while (true) {
			points.push(new Point(verts[0].xpos * - 1, verts[0].ypos, planeHeight));
			points.push(new Point(verts[1].xpos * - 1, verts[1].ypos, planeHeight));
			points.push(new Point(verts[2].xpos * - 1, verts[2].ypos, planeHeight));
			verts.splice(1, 1);
			if (verts.length == 3) {
				points.push(new Point(verts[0].xpos * - 1, verts[0].ypos, planeHeight));
				points.push(new Point(verts[1].xpos * - 1, verts[1].ypos, planeHeight));
				points.push(new Point(verts[2].xpos * - 1, verts[2].ypos, planeHeight));
				break;
			}
		}
		
		super(points);
		
		this.addNormals();
		this.addUVs();
		this.uvScale(1 / 64, 1 / 64);
		
		lumpTexture = Engine.TEXTURES.getFlat(textureName);
		
		if (MapScene.MatMap[textureName] != null) {
			material = MapScene.MatMap[textureName];
		} else {
			
			material = Material.create();
			
			assetShader = new PlaneShader(Engine.TEXTURES.playpal, lumpTexture);
			material.mainPass.addShader(assetShader);
			
			MapScene.MatMap[textureName] = material;
			
		}
		
	}
	
}