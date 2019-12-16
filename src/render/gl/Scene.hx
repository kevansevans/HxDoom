package render.gl;

import lime.graphics.RenderContext;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.math.Matrix4;
import lime.ui.Window;
import lime.utils.Float32Array;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLShader;
import render.gl.Shaders;

import hxdoom.Engine;
import hxdoom.com.Environment;
import render.gl.enums.Automap;

/**
 * ...
 * @author Kaelan
 */
class Scene 
{
	/*
	 * The Lime API mirrors the WebGL API. This does NOT mean we are limited to only using WebGL.
	 * Lime can convert WebGL to OpenGLES, and OpenGLES to OpenGL. In other words, you make a
	 * WebGL app in Lime, you can still target all of the Lime platforms (that support GL calls
	 * to begin with, of course). HOWEVER, making an OpenGL render context can not go the other
	 * way. So it is madatory that all hardware rendering code must use WebGL.
	 * 
	 * Following targets are supported with this class:
	 * HTML5 w/WebGL, Android, C++/Desktop, Hashlink
	 * 
	 * Need to test with:
	 * OSX
	 */
	var gl:WebGLRenderContext;
	var context:RenderContext;
	var window:Window;
	var program:GLProgram;
	var map_lineverts:Array<Float>;
	
	var mapVertexShader:GLShader;
	var mapFragmentShader:GLShader;
	
	public function new(_context:RenderContext, _window:Window) 
	{
		if (gl == null) {
			gl = _context.webgl;
			window = _window;
			context = _context;
				
			mapVertexShader = gl.createShader(gl.VERTEX_SHADER);
			mapFragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
				
			gl.shaderSource(mapVertexShader, Shaders.automapVertext);
			gl.shaderSource(mapFragmentShader, Shaders.automapFragment);
			
			gl.compileShader(mapVertexShader);
			if (!gl.getShaderParameter(mapVertexShader, gl.COMPILE_STATUS)) {
				throw ("Map Vertex Shadder error: \n" + gl.getShaderInfoLog(mapVertexShader));
			}
			
			gl.compileShader(mapFragmentShader);
			if (!gl.getShaderParameter(mapFragmentShader, gl.COMPILE_STATUS)) {
				throw ("Map Fragment Shader error: \n" + gl.getShaderInfoLog(mapFragmentShader));
			}
				
			program = gl.createProgram();
			
			gl.attachShader(program, mapVertexShader);
			gl.attachShader(program, mapFragmentShader);
			
			gl.linkProgram(program);
		}
	}
	public function render() {
		
		gl.viewport(0, 0, window.width, window.height);
		
		//Move this to Automap when FPS part is done.
		gl.clearColor (0, 0, 0, 1);
		gl.clear (gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
		
		if (!Environment.IS_IN_AUTOMAP) {
			drawAutoMap();
		} else {
			drawFirstPerson();
		}
		
	}
	
	function drawAutoMap() {
		
		map_lineverts = new Array();
		var loadedsegs = Engine.ACTIVEMAP.segments;
		
		var xoff = Engine.ACTIVEMAP.offset_x;
		var yoff = Engine.ACTIVEMAP.offset_y;
		
		for (segs in loadedsegs) {
			
			map_lineverts.push(segs.start.xpos);
			map_lineverts.push(segs.start.ypos);
			map_lineverts.push(0);
			
			map_lineverts.push(1);
			map_lineverts.push(1);
			map_lineverts.push(1);
			
			map_lineverts.push(segs.end.xpos);
			map_lineverts.push(segs.end.ypos);
			map_lineverts.push(0);
			
			map_lineverts.push(1);
			map_lineverts.push(1);
			map_lineverts.push(1);
		}
		
		for (vissegs in Engine.ACTIVEMAP.getVisibleSegments()) {
			map_lineverts.push(vissegs.start.xpos);
			map_lineverts.push(vissegs.start.ypos);
			map_lineverts.push(0);
			
			map_lineverts.push(1);
			map_lineverts.push(0);
			map_lineverts.push(0);
			
			map_lineverts.push(vissegs.end.xpos);
			map_lineverts.push(vissegs.end.ypos);
			map_lineverts.push(0);
			
			map_lineverts.push(1);
			map_lineverts.push(0);
			map_lineverts.push(0);
		}
		
		var loadedLineBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, loadedLineBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(map_lineverts), gl.STATIC_DRAW);
		
		var posAttributeLocation = gl.getAttribLocation(program, Automap.V3_POSITION);
		var colorAttributeLocation = gl.getAttribLocation(program, Automap.V3_COLOR);
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
		
		var automapPositionMatrixAttribute = gl.getUniformLocation(program, Automap.M4_POSITION);
		var automapFloat32 = new Float32Array(16);
		var automapMatrix4:Matrix4 = new Matrix4(automapFloat32);
		automapMatrix4.identity();
		
		automapMatrix4.appendTranslation(-Engine.ACTIVEMAP.actors_players[0].xpos, -Engine.ACTIVEMAP.actors_players[0].ypos, 0);
		automapMatrix4.appendScale(Environment.AUTOMAP_ZOOM, (Environment.AUTOMAP_ZOOM * (context.window.width / context.window.height)), 1);
		
		gl.uniformMatrix4fv(automapPositionMatrixAttribute, false, automapFloat32);
		
		var numsegs:Int = Std.int(map_lineverts.length / 6); //active maps number of segments
		
		gl.useProgram(program);
		gl.drawArrays(gl.LINES, 0, numsegs);
	}
	function drawFirstPerson() 
	{
		
	}
}