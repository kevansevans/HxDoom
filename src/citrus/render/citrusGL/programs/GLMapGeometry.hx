package citrus.render.citrusGL.programs;

import haxe.PosInfos;
import haxe.ds.Vector;
import hxdoom.lumps.map.SubSector;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.utils.Float32Array;
import mme.math.glmatrix.Mat4Tools;
import citrus.render.citrusGL.objects.GLWall;
import citrus.render.citrusGL.objects.GLFlat;

import hxdoom.Engine;
import hxdoom.common.Environment;
import hxdoom.utils.Angle;
import hxdoom.lumps.map.Segment;

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
	
	var walls:Map<Segment, Vector<GLWall>>;
	var flats:Map<SubSector, Vector<GLFlat>>;
	
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
		
		walls = new Map();
		var mapSegments = Engine.ACTIVEMAP.segments;
		
		for (seg in mapSegments) {
			
			if (seg.lineDef.solid) {
				walls[seg] = new Vector(1);
				walls[seg][0] = new GLWall(gl, seg, SideType.SOLID);
				continue;
			} else {
				walls[seg] = new Vector(6);
				
				var front = seg.lineDef.frontSideDef;
				var back = seg.lineDef.backSideDef;
				
				walls[seg][0] = new GLWall(gl, seg, SideType.FRONT_BOTTOM);
				walls[seg][1] = new GLWall(gl, seg, SideType.FRONT_MIDDLE);
				walls[seg][2] = new GLWall(gl, seg, SideType.FRONT_TOP);
				walls[seg][3] = new GLWall(gl, seg, SideType.BACK_BOTTOM);
				walls[seg][4] = new GLWall(gl, seg, SideType.BACK_MIDDLE);
				walls[seg][5] = new GLWall(gl, seg, SideType.BACK_TOP);
			}
		}
		
		flats = new Map();
		var mapSubsectors = Engine.ACTIVEMAP.subsectors;
		
		for (subsec in mapSubsectors) {
			flats[subsec] = new Vector(2);
			flats[subsec][0] = new GLFlat(gl, subsec, FlatType.FLOOR);
			flats[subsec][1] = new GLFlat(gl, subsec, FlatType.FLOOR);
		}
		
		safeToRender = true;
	}
	
	public function render(_winWidth:Int, _winHeight:Int) {
		
		if (!safeToRender) return;
		
		var worldArray = new Float32Array(16);
		var viewArray = new Float32Array(16);
		var projArray = new Float32Array(16);
		
		var p_subsector = Engine.ACTIVEMAP.getPlayerSubsector();
		var p_viewheight = p_subsector.sector.floorHeight + 41;
		
		Mat4Tools.identity(worldArray);
		Mat4Tools.lookAt(	[Engine.ACTIVEMAP.actors_players[0].xpos, Engine.ACTIVEMAP.actors_players[0].ypos, p_viewheight], 
							[Engine.ACTIVEMAP.actors_players[0].xpos_look, Engine.ACTIVEMAP.actors_players[0].ypos_look, p_viewheight + Engine.ACTIVEMAP.actors_players[0].zpos_look], 
							[0, 0, 1], viewArray);
		Mat4Tools.perspective(45 * (Math.PI / 180), (_winWidth / _winHeight), 0.1, 10000, projArray);
		
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_World"), false, worldArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_View"), false, viewArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_Proj"), false, projArray);
		
		var lastseg:Null<Segment> = null;
		for (vis_seg in Engine.RENDER.vis_segments) {
			for (plane in walls[vis_seg]) {
				if (plane == null) continue;
				plane.render(program);
			}
		}
		
		for (flat in flats) {
			flat[0].render(program);
			flat[1].render(program);
		}
	}
	
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