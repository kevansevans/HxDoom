package scene;

import h3d.Camera;
import h3d.Matrix;
import h3d.Vector;
import h3d.scene.Graphics;
import h3d.scene.Mesh;
import h3d.scene.Scene;
import haxe.ds.Map;
import h3d.mat.Material;
import scene.geometry.DebugPlane;
import scene.geometry.SectorFlat;

import hxdoom.Engine;
import hxdoom.lumps.map.Segment;
import hxdoom.lumps.map.Sector;
import hxdoom.enums.eng.SideType;
import hxdoom.enums.eng.PlaneType;

import scene.geometry.QuadWall;
//import scene.geometry.SectorFlat;
import hxdoom.component.Actor;

/**
 * ...
 * @author Kaelan
 */
class MapScene 
{
	var s3d:Scene;
	
	public static var MatMap:Map<String, Material> = new Map();
	
	public var quad_walls:Map<Segment, Array<QuadWall>>;
	//public var poly_flats:Map<Sector, SectorFlat>;
	var m_walls:Map<Segment, Array<Mesh>>;
	var vis_list:Array<Segment>;
	
	public var camera:Camera;
	
	public var gfx:Graphics;
	
	public function new(_s3d:Scene) 
	{
		s3d = _s3d;
		
		quad_walls = new Map();
		//poly_flats = new Map();
		m_walls = new Map();
		vis_list = new Array();
		
		Engine.TEXTURES.parsePatchNames();
		Engine.TEXTURES.parseTextures();
		
		camera = s3d.camera = new Camera(90, 2, 320 / 200);
		
		gfx = new Graphics(s3d);
		
	}
	
	public function buildMap() {
		
		for (seg in Engine.LEVELS.currentMap.segments) {
			
			var line = seg.lineDef;
			
			var meshes:Array<Mesh> = new Array();
			m_walls[seg] = meshes;
			quad_walls[seg] = new Array();
			
			var matrix = new Matrix();
			matrix.colorLightness(seg.sector.lightLevel / 255);
			var color = new Vector(1, 0, 0);
			color.transform3x4(matrix);
			color.setColor(color.toColor());
			
			if (line.solid) {
				
					if (line.frontSideDef.middle_texture != "-" && line.frontSideDef.middle_texture != "AASTINKY") {
						
						var solid_wall:QuadWall = new QuadWall(seg, SideType.SOLID);
						var mesh = new Mesh(solid_wall, solid_wall.material, s3d);
						
						mesh.visible = false;
						meshes.push(mesh);
						quad_walls[seg].push(solid_wall);
						
					}
					
			} else {
					
					if (line.frontSideDef.upper_texture != "-" && line.frontSideDef.upper_texture != "AASTINKY") {
						if (line.backSideDef.sector.ceilingTexture != "F_SKY1") {
							
							var top_front:QuadWall = new QuadWall(seg, SideType.FRONT_TOP);
							var tf_mesh = new Mesh(top_front, top_front.material, s3d);
							
							tf_mesh.visible = false;
							meshes.push(tf_mesh);
							quad_walls[seg].push(top_front);
							
						}
					}
					
					if (line.frontSideDef.middle_texture != "-" && line.frontSideDef.middle_texture != "AASTINKY") {
						
						var mid_front:QuadWall = new QuadWall(seg, SideType.FRONT_MIDDLE);
						var mf_mesh = new Mesh(mid_front, mid_front.material, s3d);
						
						mf_mesh.visible = false;
						meshes.push(mf_mesh);
						quad_walls[seg].push(mid_front);
						
					}
					
					if (line.frontSideDef.lower_texture != "-" && line.frontSideDef.lower_texture != "AASTINKY") {
						
						var low_front:QuadWall = new QuadWall(seg, SideType.FRONT_BOTTOM);
						var lf_mesh = new Mesh(low_front, low_front.material, s3d);
						
						lf_mesh.visible = false;
						meshes.push(lf_mesh);
						quad_walls[seg].push(low_front);
					}
					
					if (line.backSideDef.upper_texture != "-" && line.backSideDef.upper_texture != "AASTINKY") {
						
						var top_back:QuadWall = new QuadWall(seg, SideType.BACK_TOP);
						var tb_mesh = new Mesh(top_back, top_back.material, s3d);
						
						tb_mesh.visible = false;
						meshes.push(tb_mesh);
						quad_walls[seg].push(top_back);
						
					}
					
					if (line.backSideDef.middle_texture != "-" && line.backSideDef.middle_texture != "AASTINKY") {
						
						var mid_back:QuadWall = new QuadWall(seg, SideType.BACK_MIDDLE);
						var mb_mesh = new Mesh(mid_back, mid_back.material, s3d);
						
						mb_mesh.visible = false;
						meshes.push(mb_mesh);
						quad_walls[seg].push(mid_back);
					}
					
					if (line.backSideDef.lower_texture != "-" && line.backSideDef.lower_texture != "AASTINKY") {
						
						var low_back:QuadWall = new QuadWall(seg, SideType.BACK_BOTTOM);
						var lb_mesh = new Mesh(low_back, low_back.material, s3d);
						
						lb_mesh.visible = false;
						meshes.push(lb_mesh);
						quad_walls[seg].push(low_back);
						
					}
					
			}
			
			for (mesh in meshes) {
				mesh.material.color.load(color);
			}
		}
		
		for (sector in Engine.LEVELS.currentMap.sectors) {
			gfx.lineStyle(2, Std.int(Math.random() * 0xFFFFFF));
			for (line in sector.lines) {
				gfx.moveTo(line.start.xpos * -1, line.start.ypos, sector.floorHeight);
				gfx.lineTo(line.end.xpos * -1, line.end.ypos, sector.floorHeight);
				gfx.moveTo(line.start.xpos * -1, line.start.ypos, sector.ceilingHeight);
				gfx.lineTo(line.end.xpos * -1, line.end.ypos, sector.ceilingHeight);
			}
		}
	}
	
	public function disposeMap() {
		for (wall in m_walls) {
			for (segwall in wall) {
				s3d.removeChild(segwall);
			}
		}
	}
	
	public function update() {
		
		Engine.RENDER.setVisibleSegments();
		
		var vis_seg = Engine.RENDER.vis_segments;
		
		if (vis_seg == null) return;
		
		for (seg in vis_seg) {
			if (!vis_list.contains(seg)) {
				
				if (m_walls[seg] == null) continue;
				
				for (mesh in m_walls[seg]) {
					mesh.visible = true;
				}
				for (quad in quad_walls[seg]) {
					quad.updateGeneral();
				}
				vis_list.push(seg);
			}
		}
		
		for (seg in vis_list) {
			if (!vis_seg.contains(seg)) {
				
				if (m_walls[seg] == null) continue;
				
				for (mesh in m_walls[seg]) {
					mesh.visible = false;
				}
				vis_list.remove(seg);
			}
		}
		
		var player = Engine.LEVELS.currentMap.actors_players[0];
		var focus = Engine.LEVELS.currentMap.focus;
		var f_vec:Vector = new Vector(focus.x * -1, focus.y, player.zpos_view);
		
		camera.pos.set(player.xpos * -1, player.ypos, player.zpos_view);
		camera.target = f_vec;
	}
	
}