package render.citrusGL.programs;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.utils.Float32Array;
import mme.math.glmatrix.Mat4Tools;
import render.citrusGL.objects.GLWall;

import hxdoom.Engine;
import hxdoom.common.Environment;
import hxdoom.abstracts.Angle;

/**
 * ...
 * @author Kaelan
 */
class GLMapGeometry 
{
	var gl:WebGLRenderContext;
	var program:GLProgram;
	
	var vertex_shader:GLShader;
	var fragment_shader:GLShader;
	
	var planes:Array<GLWall>;
	
	var safeToRender:Bool = false;
	
	public function new(_gl:WebGLRenderContext)
	{
		gl = _gl;
		program = gl.createProgram();
		
		vertex_shader = gl.createShader(gl.VERTEX_SHADER);
		fragment_shader = gl.createShader(gl.FRAGMENT_SHADER);
				
		gl.shaderSource(vertex_shader, GLMapGeometry.vertex_source);
		gl.shaderSource(fragment_shader, GLMapGeometry.fragment_source);
		
		gl.compileShader(vertex_shader);
		if (!gl.getShaderParameter(vertex_shader, gl.COMPILE_STATUS)) {
			throw ("Map Vertex Shadder error: \n" + gl.getShaderInfoLog(vertex_shader));
		}
		
		gl.compileShader(fragment_shader);
		if (!gl.getShaderParameter(fragment_shader, gl.COMPILE_STATUS)) {
			throw ("Map Fragment Shader error: \n" + gl.getShaderInfoLog(fragment_shader));
		}
		
		program = gl.createProgram();
			
		gl.attachShader(program, vertex_shader);
		gl.attachShader(program, fragment_shader);
			
		gl.linkProgram(program);
		
	}
	
	public function buildMapGeometry() {
		safeToRender = false;
		
		var mapSegments = Engine.ACTIVEMAP.segments;
		
		var numplanes:Int = 0;
		for (seg in mapSegments) {
			if (seg.lineDef.solid) {
				numplanes += 1;
				continue;
			}
			if (seg.lineDef.frontSideDef.lower_texture != "-") numplanes += 1;
			if (seg.lineDef.frontSideDef.middle_texture != "-") numplanes += 1;
			if (seg.lineDef.frontSideDef.upper_texture != "-") numplanes += 1;
			if (seg.lineDef.backSideDef.lower_texture != "-") numplanes += 1;
			if (seg.lineDef.backSideDef.middle_texture != "-") numplanes += 1;
			if (seg.lineDef.backSideDef.upper_texture != "-") numplanes += 1;
		}
		
		planes = new Array();
		planes.resize(numplanes);
		
		var p_index = 0;
		
		for (s_index in 0...mapSegments.length) {
			var segment = mapSegments[s_index];
			
			if (segment.lineDef.solid) {
				planes[p_index] = new GLWall(gl, mapSegments[s_index], SideType.SOLID);
			} else {
				if (segment.lineDef.frontSideDef.lower_texture != "-") {
					planes[p_index] = new GLWall(gl, mapSegments[s_index], SideType.FRONT_BOTTOM);
				}
				if (segment.lineDef.frontSideDef.middle_texture != "-") {
					planes[p_index += 1] = new GLWall(gl, mapSegments[s_index], SideType.FRONT_MIDDLE);
				}
				if (segment.lineDef.frontSideDef.upper_texture != "-") {
					planes[p_index += 1] = new GLWall(gl, mapSegments[s_index], SideType.FRONT_TOP);
				}
				if (segment.lineDef.backSideDef.lower_texture != "-") {
					planes[p_index += 1] = new GLWall(gl, mapSegments[s_index], SideType.BACK_BOTTOM);
				}
				if (segment.lineDef.backSideDef.middle_texture != "-") {
					planes[p_index += 1] = new GLWall(gl, mapSegments[s_index], SideType.BACK_MIDDLE);
				}
				if (segment.lineDef.backSideDef.upper_texture != "-") {
					planes[p_index += 1] = new GLWall(gl, mapSegments[s_index], SideType.BACK_TOP);
				}
			}
			
			++p_index;
		}
		
		safeToRender = true;
	}
	
	public function render(_winWidth:Int, _winHeight:Int) {
		
		if (!safeToRender) return;
		
		var worldArray = new Float32Array(16);
		var viewArray = new Float32Array(16);
		var projArray = new Float32Array(16);
		
		var p_subsector = Engine.ACTIVEMAP.getPlayerSubsector();
		var p_segment = p_subsector.segments[0];
		var p_viewheight = p_segment.frontSector.floorHeight + 41;
		
		var startAngle:Angle =  Engine.ACTIVEMAP.actors_players[0].angleToVertex(p_segment.start) - Engine.ACTIVEMAP.actors_players[0].angle;
		var endAngle:Angle =  Engine.ACTIVEMAP.actors_players[0].angleToVertex(p_segment.end) - Engine.ACTIVEMAP.actors_players[0].angle;
		var span:Angle = startAngle - endAngle;
		
		Mat4Tools.identity(worldArray);
		Mat4Tools.lookAt(	[Engine.ACTIVEMAP.actors_players[0].xpos, Engine.ACTIVEMAP.actors_players[0].ypos, p_viewheight], 
							[Engine.ACTIVEMAP.actors_players[0].xpos_look, Engine.ACTIVEMAP.actors_players[0].ypos_look, p_viewheight + Engine.ACTIVEMAP.actors_players[0].zpos_look], 
							[0, 0, 1], viewArray);
		Mat4Tools.perspective(45 * (Math.PI / 180), _winWidth / _winHeight, 0.1, 10000, projArray);
		
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_World"), false, worldArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_View"), false, viewArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_Proj"), false, projArray);
		
		for (plane in planes) {
			if (plane == null) continue;
			plane.bind(program);
			plane.render();
		}
	}
	
	/*public function buildMapArray() {
		
		var loadedsegs = Engine.ACTIVEMAP.getVisibleSegments();
		var sectors = Engine.ACTIVEMAP.sectors;
		var numSegs = ((loadedsegs.length -1) * 42);
		map_lineverts.resize(numSegs);
		var itemCount:Int = 0;
		
		for (segs in 0...loadedsegs.length) {
			
			if (loadedsegs[segs].lineDef.solid) {
			
				map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
				
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
				map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
				map_lineverts[itemCount += 1] 	= 1.0;
				
				++itemCount;
			}
			else {
				
				if (loadedsegs[segs].lineDef.frontSideDef.lower_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					++itemCount;
				}
				
				if (loadedsegs[segs].lineDef.frontSideDef.middle_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					++itemCount;
				}
				
				if (loadedsegs[segs].lineDef.frontSideDef.upper_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					++itemCount;
				}
				
				if (loadedsegs[segs].lineDef.backSideDef.lower_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					++itemCount;
				}
				
				if (loadedsegs[segs].lineDef.backSideDef.middle_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.floorHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 0.2;
					
					++itemCount;
				}
				
				if (loadedsegs[segs].lineDef.backSideDef.upper_texture != "-") {
					
					map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].backSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].frontSector.ceilingHeight;
					
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
					map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
					map_lineverts[itemCount += 1] 	= 1.0;
					
					++itemCount;
				}
			}
		}
		
		Environment.NEEDS_TO_REBUILD_AUTOMAP = false;
	}*/
	
	public static var vertex_source:String = [
	#if !desktop
	'precision mediump float;',
	#end
	'attribute vec3 V3_POSITION;',
	'attribute vec4 V4_COLOR;',
	'varying vec4 F_COLOR;',
	'uniform mat4 M4_World;',
	'uniform mat4 M4_View;',
	'uniform mat4 M4_Proj;',
	'',
	'void main()',
	'{',
	'	F_COLOR = V4_COLOR;',
	'	gl_Position = M4_Proj * M4_View * M4_World * vec4(V3_POSITION, 1.0);',
	'}'
	].join('\n');
	
	public static var fragment_source:String = [
	#if !desktop
	'precision mediump float;',
	#end
	'varying vec4 F_COLOR;',
	'',
	'void main()',
	'{',
	' 	gl_FragColor = F_COLOR;',
	'}'
	].join('\n');
	
}