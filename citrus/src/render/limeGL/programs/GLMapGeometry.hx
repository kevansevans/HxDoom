package render.limeGL.programs;

import haxe.PosInfos;
import haxe.ds.Map;
import haxe.ds.Vector;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;
import lime.graphics.Image;

import mme.math.glmatrix.Mat4Tools;

import render.limeGL.objects.GLWall;
import render.limeGL.objects.GLFlat;

import hxdoom.Engine;
import hxdoom.enums.eng.SideType;
import hxdoom.lumps.map.Node;
import hxdoom.lumps.map.Segment;
import hxdoom.lumps.map.SubSector;
import hxdoom.lumps.map.Sector;
import hxdoom.utils.geom.Angle;
import hxdoom.utils.extensions.Camera;
import hxdoom.utils.extensions.CameraPoint;
import hxdoom.actors.Actor;
import hxdoom.lumps.graphic.Texture;

/**
 * ...
 * @author Kaelan
 */
typedef TexData = {
	var name : String;
	var glIndex : Int;
	var limeImage : Image;
	var texture : Texture;
}

class GLMapGeometry 
{
	var gl:WebGLRenderContext;
	var program:GLProgram;
	
	var vertex_shader:GLShader;
	var fragment_shader:GLShader;
	
	var walls:Map<Segment, Vector<GLWall>>;
	var midwalls:Map<Segment, Vector<GLWall>>;
	var flats:Map<Sector, Vector<GLFlat>>;
	var visflats:Array<Vector<GLFlat>>;
	
	var safeToRender:Bool = false;
	
	public static var textureCache:Map<String, TexData>;
	public static var glTextureIndex:Int = 0;
	
	public function new(_gl:WebGLRenderContext)
	{
		gl = _gl;
		program = gl.createProgram();
		
		textureCache = new Map();
		
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
		midwalls = new Map();
		flats = new Map();
		
		var mapSegments = Engine.LEVELS.currentMap.segments;	
		for (seg in mapSegments) {
			
			if (seg.lineDef.solid) {
				walls[seg] = new Vector(1);
				walls[seg][0] = new GLWall(gl, seg, SideType.SOLID);
			} else {
				walls[seg] = new Vector(4);
				midwalls[seg] = new Vector(2);
				
				var front = seg.lineDef.frontSideDef;
				var back = seg.lineDef.backSideDef;
				
				walls[seg][0] = new GLWall(gl, seg, SideType.FRONT_BOTTOM);
				walls[seg][1] = new GLWall(gl, seg, SideType.FRONT_TOP);
				walls[seg][2] = new GLWall(gl, seg, SideType.BACK_BOTTOM);
				walls[seg][3] = new GLWall(gl, seg, SideType.BACK_TOP);
				
				midwalls[seg][0] = new GLWall(gl, seg, SideType.FRONT_MIDDLE);
				midwalls[seg][1] = new GLWall(gl, seg, SideType.BACK_MIDDLE);
			}
			
			if (flats[seg.sector] == null) {
				flats[seg.sector] = new Vector(2);
				flats[seg.sector][0] = new GLFlat(gl, FLOOR);
				flats[seg.sector][1] = new GLFlat(gl, CEILING);
			}
			
			flats[seg.sector][0].addSegment(seg);
			flats[seg.sector][1].addSegment(seg);
		}
		
		for (flat in flats) {
			//flat[0].buildShells();
			//flat[1].buildShells();
		}
		
		safeToRender = true;
	}
	
	
	public function render(_winWidth:Int, _winHeight:Int) {
		
		if (Engine.LEVELS.needToRebuild) {
			safeToRender = false;
			buildMapGeometry();
		}
		
		if (!safeToRender) return;
		
		gl.useProgram(program);
		
		var worldArray = new Float32Array(16);
		var viewArray = new Float32Array(16);
		var projArray = new Float32Array(16);
		
		var camera:Camera = Engine.LEVELS.currentMap.camera;
		var focus:CameraPoint = Engine.LEVELS.currentMap.focus;
		
		Mat4Tools.identity(worldArray);
		Mat4Tools.lookAt(	[camera.xpos, camera.ypos, camera.zpos], 
							[focus.x, focus.y, focus.z], 
							[0, 0, 1], viewArray);
		Mat4Tools.perspective(45 * (Math.PI / 180), (320 / 200), 0.1, 10000, projArray);
		
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_World"), false, worldArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_View"), false, viewArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_Proj"), false, projArray);
		
		var lastseg:Null<Segment> = null;
		visflats = new Array();
		for (vis_seg in Engine.RENDER.vis_segments) {
			for (plane in walls[vis_seg]) {
				if (plane == null) continue;
				plane.render(program);
			}
		}
		for (vis_seg in Engine.RENDER.vis_segments) {
			if (vis_seg.lineDef.solid) continue;
			else {
				for (plane in midwalls[vis_seg]) {
					if (plane == null) continue;
					plane.render(program);
				}
			}
		}
	}
	
	public static var vertex_source:String = [
	#if !desktop
	'precision mediump float;',
	#end
	'attribute vec3 V3_POSITION;',
	'uniform mat4 M4_World;',
	'uniform mat4 M4_View;',
	'uniform mat4 M4_Proj;',
	'varying vec2 fragTexCoord;',
	'attribute vec2 vTextureCoord;',
	'',
	'void main()',
	'{',
	'	fragTexCoord = vTextureCoord;',
	'	gl_Position = M4_Proj * M4_View * M4_World * vec4(V3_POSITION, 1.0);',
	'}'
	].join('\n');
	
	public static var fragment_source:String = [
	#if !desktop
	'precision mediump float;',
	#end
	'',
	'varying vec2 vTextureCoord;',
	'uniform sampler2D uSampler;',
	'varying vec2 fragTexCoord;',
	'void main()',
	'{',
	' 	gl_FragColor = texture2D(uSampler, fragTexCoord);' ,
	'}'
	].join('\n');
	
}