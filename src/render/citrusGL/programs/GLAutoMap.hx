package render.citrusGL.programs;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.math.Matrix4;
import lime.math.Vector4;
import lime.utils.Float32Array;

import hxdoom.Engine;
import hxdoom.common.Environment;

/**
 * ...
 * @author Kaelan
 */
class GLAutoMap
{
	var gl:WebGLRenderContext;
	var program:GLProgram;
	
	var vertex_shader:GLShader;
	var fragment_shader:GLShader;
	var automapMatrix4:Matrix4;
	var automapFloat32:Float32Array;
	
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

	public function render(_winWidth:Int, _winHeight:Int) {
		
		rebuildMapArray();
		
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
		
		automapFloat32 = new Float32Array(16);
		automapMatrix4 = new Matrix4(automapFloat32);
		automapMatrix4.identity();
		
		gl.useProgram(program);
			
		automapMatrix4.appendTranslation( -Engine.ACTIVEMAP.actors_players[0].xpos, -Engine.ACTIVEMAP.actors_players[0].ypos, 0);
		if (Environment.AUTOMAP_ROTATES_WITH_PLAYER) automapMatrix4.appendRotation(Engine.ACTIVEMAP.actors_players[0].angle - 90, new Vector4(0, 0, -1, 1));
		automapMatrix4.appendScale(Environment.AUTOMAP_ZOOM, (Environment.AUTOMAP_ZOOM * (_winWidth / _winHeight)), 1);
		
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_POSITION"), false, automapFloat32);
			
		gl.lineWidth(1 / (2 / Environment.AUTOMAP_ZOOM));
		gl.drawArrays(gl.LINES, 0, Std.int(map_lineverts.length / 6));
	}
	
	function rebuildMapArray() {
		var loadedsegs = Engine.ACTIVEMAP.segments;
		var numSegs = ((loadedsegs.length -1) * 12);
		map_lineverts.resize(numSegs);
		var itemCount:Int = 0;
		
		for (segs in 0...loadedsegs.length) {
			
			map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
			map_lineverts[itemCount += 1] 	= 0;
			
			map_lineverts[itemCount += 1] 	= 1;
			map_lineverts[itemCount += 1] 	= 1;
			map_lineverts[itemCount += 1] 	= 1;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
			map_lineverts[itemCount += 1] 	= 0;
			
			map_lineverts[itemCount += 1] 	= 1;
			map_lineverts[itemCount += 1] 	= 1;
			map_lineverts[itemCount += 1] 	= 1;
			
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
	'uniform mat4 M4_POSITION;',
	'',
	'void main()',
	'{',
	'	F_COLOR = V3_COLOR;',
	'	gl_Position = M4_POSITION * vec4(V3_POSITION, 1.0);',
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