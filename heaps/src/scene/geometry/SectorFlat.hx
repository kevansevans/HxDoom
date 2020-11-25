package scene.geometry;

import h3d.prim.Polygon;
import h3d.col.Point;
import h3d.mat.Material;
import h3d.mat.Data.Face;

import hxdoom.Engine;
import hxdoom.core.Reader;
import hxdoom.enums.eng.PlaneType;
import hxdoom.lumps.graphic.Flat;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Sector;
import hxdoom.lumps.map.Vertex;

import scene.shader.PaletteShader;

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
	var assetShader:PaletteShader;
	
	public function new(_sector:Sector, _plane:PlaneType) 
	{
		sector = _sector;
		
		var textureName:String = "-";
		var planeHeight:Float = 0;
		
		switch (_plane) {
			case PlaneType.FLOOR | PlaneType.FALSE :
				textureName = _sector.floorTexture;
				planeHeight = _sector.floorHeight;
			case PlaneType.CEILING :
				textureName = _sector.ceilingTexture;
				planeHeight = _sector.ceilingHeight;
		}
		
		var verts = Sector.getSortedVerticies(_sector);
		
		verts.reverse();
		
		var tris:Array<Point> = new Array();
		
		var levverts = Engine.LEVELS.currentMap.vertexes;
		
		while (true) {
			
			if (verts.length == 3) {
				
				tris.push(new Point(verts[0].xpos * -1, verts[0].ypos, planeHeight));
				tris.push(new Point(verts[1].xpos * -1, verts[1].ypos, planeHeight));
				tris.push(new Point(verts[2].xpos * -1, verts[2].ypos, planeHeight));
				
				break;
			}
			
			var a:Vertex = verts[0];
			var b:Vertex = verts[1];
			var c:Vertex = verts[2];
			
			if (a == null || b == null || c == null) break;
			
			var dir = getDirection(a, b, c);
			
			//trace(dir, levverts.indexOf(a), levverts.indexOf(b), levverts.indexOf(c));
			
			if (dir == 0) {
				
				//trace("line flat");
				
				verts.remove(b);
				continue;
				
			} else {
				
				if (dir < 0) {
					verts.push(verts.shift());
					//trace("Not a inner tri");
				} else {
					
					var valid:Bool = true;
					
					for (vert in verts) {
						if (vert == a || vert == b || vert == c) continue;
						else {
							if (pointLiesInTri(a, b, c, vert)) {
								valid = false;
								verts.push(verts.shift());
								//trace("tri intersects");
								break;
							}
						}
					}
					
					if (valid) {
						
						tris.push(new Point(a.xpos * -1, a.ypos, planeHeight));
						tris.push(new Point(b.xpos * -1, b.ypos, planeHeight));
						tris.push(new Point(c.xpos * -1, c.ypos, planeHeight));
						
						verts.remove(b);
						verts.push(verts.shift());
						verts.push(verts.shift());
						
						//trace("tri is kosher");
					}
					
				}
				
			}
			
			if (verts.length == 3) {
				
				tris.push(new Point(verts[0].xpos * -1, verts[0].ypos, planeHeight));
				tris.push(new Point(verts[1].xpos * -1, verts[1].ypos, planeHeight));
				tris.push(new Point(verts[2].xpos * -1, verts[2].ypos, planeHeight));
				
				break;
			}
		}
		
		super(tris);
		
		this.addNormals();
		this.addUVs();
		this.uvScale(1 / 64, 1 / 64);
		
		lumpTexture = Engine.TEXTURES.getFlat(textureName);
			
		material = Material.create();
			
		assetShader = new PaletteShader(Engine.TEXTURES.playpal, lumpTexture);
		material.mainPass.addShader(assetShader);
		
		if (_plane == PlaneType.CEILING) {
			material.mainPass.culling = Face.Front;
		}
		
	}
	
	public function getDirection(_a:Vertex, _b:Vertex, _c:Vertex):Float
	{
		return ((_b.ypos - _a.ypos) * (_c.xpos - _b.xpos) - (_b.xpos - _a.xpos) * (_c.ypos - _b.ypos));
	}
	
	public function triArea(_a:Vertex, _b:Vertex, _c:Vertex):Float
	{
		return Math.abs((_a.xpos * (_b.ypos - _c.ypos) + _b.xpos * (_c.ypos - _a.ypos) + _c.xpos * (_a.ypos - _b.ypos)) / 2);
	}
	
	public function pointLiesInTri(_a:Vertex, _b:Vertex, _c:Vertex, _p:Vertex):Bool 
	{
		var area:Float = triArea(_a, _b, _c);
		
		var a1:Float = triArea(_p, _b, _c);
		var a2:Float = triArea(_a, _p, _c);
		var a3:Float = triArea(_a, _b, _p);
		
		return (area == a1 + a2 + a3);
	}
}