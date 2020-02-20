package render.gl.programs;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.math.Matrix4;
import lime.math.Vector4;
import lime.utils.Float32Array;

import hxdoom.Engine;
import hxdoom.com.Environment;

/**
 * ...
 * @author Kaelan
 */
class GLFirstPerson 
{
	var gl:WebGLRenderContext;
	var program:GLProgram;
	
	var vertex_shader:GLShader;
	var fragment_shader:GLShader;
	
	var worldMatrix4:Matrix4;
	var worldArray:Float32Array;
	var viewMatrix4:Matrix4;
	var viewArray:Float32Array;
	var projMatrix4:Matrix4;
	var projArray:Float32Array;
	
	var map_lineverts:Array<Float>;
	
	public function new(_gl:WebGLRenderContext)
	{
		gl = _gl;
		program = gl.createProgram();
		map_lineverts = new Array();
		
		vertex_shader = gl.createShader(gl.VERTEX_SHADER);
		fragment_shader = gl.createShader(gl.FRAGMENT_SHADER);
				
		gl.shaderSource(vertex_shader, GLAutoMap.vertex_source);
		gl.shaderSource(fragment_shader, GLAutoMap.fragment_source);
		
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
	
	function bindAttributes() 
	{
		var loadedLineBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, loadedLineBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(map_lineverts), gl.STATIC_DRAW);
		
		var posAttributeLocation = gl.getAttribLocation(program, "V3_POSITION");
		var colorAttributeLocation = gl.getAttribLocation(program, "V3_COLOR");
		gl.vertexAttribPointer(
			posAttributeLocation,
			3,
			gl.FLOAT,
			false,
			6 * Float32Array.BYTES_PER_ELEMENT,
			0);
		gl.vertexAttribPointer(
			colorAttributeLocation,
			3,
			gl.FLOAT,
			false,
			6 * Float32Array.BYTES_PER_ELEMENT,
			3 * Float32Array.BYTES_PER_ELEMENT);
		gl.enableVertexAttribArray(posAttributeLocation);
		gl.enableVertexAttribArray(colorAttributeLocation);
		
		var p_vec4 = new Vector4(Engine.ACTIVEMAP.actors_players[0].xpos, 0, Engine.ACTIVEMAP.actors_players[0].ypos, 0);
		var pc_vec4 = p_vec4;
		pc_vec4.x += 5;
		
		worldArray = new Float32Array(16);
		worldMatrix4 = new Matrix4(worldArray);
		worldMatrix4.identity();
		viewArray = new Float32Array(16);
		viewMatrix4 = new Matrix4(viewArray);
		//viewMatrix4.pointAt(p_vec4, pc_vec4, new Vector4(0, 1, 0, 0));
		projArray = new Float32Array(16);
		projMatrix4 = new Matrix4(projArray);
		//projMatrix4.createOrtho( -1, 1, -1, 1, 0.1, 4000);
	}
	
	public function render(_winWidth:Int, _winHeight:Int) {
		
		rebuildMapArray();
		
		bindAttributes();
		
		gl.useProgram(program);
			
		gl.clearColor (0, 0, 0, 1);
		gl.clear (gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
		
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_World"), false, worldArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_View"), false, viewArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_Proj"), false, projArray);
		
		gl.drawArrays(gl.LINES, 0, Std.int(map_lineverts.length / 6));
	}
	
	function rebuildMapArray() {
		var loadedsegs = Engine.ACTIVEMAP.getVisibleSegments();
		var sectors = Engine.ACTIVEMAP.sectors;
		var visSegs = Engine.ACTIVEMAP.getVisibleSegments();
		var numSegs = ((loadedsegs.length -1) * 36);
		map_lineverts.resize(numSegs);
		var itemCount:Int = 0;
		
		for (segs in 0...loadedsegs.length) {
			var randswatch = Std.int(255 * Math.random());
			
			var r_color = Engine.PLAYPAL.getColor(randswatch, 0, 0, true); 
			var g_color = Engine.PLAYPAL.getColor(randswatch, 1, 0, true); 
			var b_color = Engine.PLAYPAL.getColor(randswatch, 2, 0, true);
			
			map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
			map_lineverts[itemCount += 1] 	= sectors[loadedsegs[segs].lineDef.sectorTag].floorHeight;
			
			map_lineverts[itemCount += 1] 	= r_color;
			map_lineverts[itemCount += 1] 	= g_color;
			map_lineverts[itemCount += 1] 	= b_color;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
			map_lineverts[itemCount += 1] 	= sectors[loadedsegs[segs].lineDef.sectorTag].floorHeight;
			
			map_lineverts[itemCount += 1] 	= r_color;
			map_lineverts[itemCount += 1] 	= g_color;
			map_lineverts[itemCount += 1] 	= b_color;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
			map_lineverts[itemCount += 1] 	= sectors[loadedsegs[segs].lineDef.sectorTag].ceilingHeight;
			
			map_lineverts[itemCount += 1] 	= r_color;
			map_lineverts[itemCount += 1] 	= g_color;
			map_lineverts[itemCount += 1] 	= b_color;
			
			////////////////////////////////////////////////////////////////////////////////////////////////////
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
			map_lineverts[itemCount += 1] 	= sectors[loadedsegs[segs].lineDef.sectorTag].ceilingHeight;
			
			map_lineverts[itemCount += 1] 	= r_color;
			map_lineverts[itemCount += 1] 	= g_color;
			map_lineverts[itemCount += 1] 	= b_color;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
			map_lineverts[itemCount += 1] 	= sectors[loadedsegs[segs].lineDef.sectorTag].ceilingHeight;
			
			map_lineverts[itemCount += 1] 	= r_color;
			map_lineverts[itemCount += 1] 	= g_color;
			map_lineverts[itemCount += 1] 	= b_color;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
			map_lineverts[itemCount += 1] 	= sectors[loadedsegs[segs].lineDef.sectorTag].floorHeight;
			
			map_lineverts[itemCount += 1] 	= r_color;
			map_lineverts[itemCount += 1] 	= g_color;
			map_lineverts[itemCount += 1] 	= b_color;
			
			++itemCount;
		}
		
		Environment.NEEDS_TO_REBUILD_AUTOMAP = false;
	}
	
	public static var vertex_source:String = [
	#if !desktop
	'precision mediump float;',
	#end
	'attribute vec3 V3_POSITION;',
	'attribute vec3 V3_COLOR;',
	'varying vec3 F_COLOR;',
	'uniform mat4 M4_World;',
	'uniform mat4 M4_View;',
	'uniform mat4 M4_Proj;',
	'',
	'void main()',
	'{',
	'	F_COLOR = V3_COLOR;',
	'	gl_Position = M4_Proj * M4_View * M4_World * vec4(V3_POSITION, 1.0);',
	'}'
	].join('\n');
	
	public static var fragment_source:String = [
	#if !desktop
	'precision mediump float;',
	#end
	'varying vec3 F_COLOR;',
	'',
	'void main()',
	'{',
	' 	gl_FragColor = vec4(F_COLOR, 1.0);',
	'}'
	].join('\n');
	
}