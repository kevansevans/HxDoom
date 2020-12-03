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
	public var verts:Array<Vertex>;
	public var problem:Vertex;
	var lumpTexture:Flat;
	public var material:Material;
	var assetShader:PaletteShader;
	
	var triFails:Int = 0;
	
	public var hxTriCount:Int = 0;
	public var failtri:Array<Vertex>;
	public var mid:Vertex;
	
	public function new(_sector:Sector, _plane:PlaneType, ?_debug:Bool = false, ?_failLimit:Int = 0) 
	{
		sector = _sector;
		
		var sectorindex = Engine.LEVELS.currentMap.sectors.indexOf(_sector);
		
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
		
		verts = Sector.getSortedVerticies(_sector).copy();
		var originalVerts = verts.copy();
		
		var trilimit = verts.length - 2;
		
		verts.reverse();
		
		var tris:Array<Point> = new Array();
		
		while (true) {
			
			if (_debug && triFails == _failLimit) {
				
				break;
			}
			
			if (Std.int(tris.length / 3) == trilimit) break;
			
			var a:Vertex = verts[0];
			var b:Vertex = verts[1];
			var c:Vertex = verts[2];
			
			var dir = getDirection(a, b, c);
			
			if (verts.length == 3) {
				
				if (dir > 0) {
					tris.push(new Point(a.xpos * -1, a.ypos, planeHeight));
					tris.push(new Point(b.xpos * -1, b.ypos, planeHeight));
					tris.push(new Point(c.xpos * -1, c.ypos, planeHeight));
				} else {
					tris.push(new Point(a.xpos * -1, a.ypos, planeHeight));
					tris.push(new Point(c.xpos * -1, c.ypos, planeHeight));
					tris.push(new Point(b.xpos * -1, b.ypos, planeHeight));
				}
				
				hxTriCount++;
				
				break;
			}
			
			
			
			if (dir == 0) {
				
				verts.remove(b);
				
				trilimit -= 1;
				
				continue;
				
			} else {
				
				if (dir < 0) {
					
					if (_debug) {
						
						var a:Vertex = verts[0];
						var b:Vertex = verts[1];
						var c:Vertex = verts[2];
						
						failtri = new Array();
						failtri.push(a);
						failtri.push(b);
						failtri.push(c);
					}
						
					verts.push(verts.shift());
						
					if (_debug) triFails++;
					
				} else {
					
					var valid:Bool = true;
					
					for (vert in originalVerts) {
						
						if ((vert.xpos == a.xpos && vert.ypos == a.ypos) || (vert.xpos == b.xpos && vert.ypos == b.ypos) || (vert.xpos == c.xpos && vert.ypos == c.ypos)) continue;
						
						if (pointLiesInTri(a, b, c, vert)) {
							
							if (getDirection(a, b, vert) == 0 || getDirection(b, c, vert) == 0) {
								verts.push(verts.shift());
								break;
							}
								
							if (_debug) {
								
								var a:Vertex = verts[0];
								var b:Vertex = verts[1];
								var c:Vertex = verts[2];
								
								failtri = new Array();
								failtri.push(a);
								failtri.push(b);
								failtri.push(c);
							}
							
							valid = false;
							problem = vert;
							verts.push(verts.shift());
							if (_debug) triFails++;
							break;
						}
					}
					
					if (valid) {
						
						tris.push(new Point(a.xpos * -1, a.ypos, planeHeight));
						tris.push(new Point(b.xpos * -1, b.ypos, planeHeight));
						tris.push(new Point(c.xpos * -1, c.ypos, planeHeight));
						
						verts.remove(b);
						
						hxTriCount++;
						triFails = 0;
					}
				}
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
		
		//material.mainPass.wireframe = true;
		
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