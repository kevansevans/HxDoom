package render.gl;

import lime.graphics.RenderContext;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.math.Matrix4;
import lime.math.Vector4;
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
	var automapMatrix4:Matrix4;
	var automapFloat32:Float32Array;
	
	public function new(_context:RenderContext, _window:Window) 
	{
		if (gl == null) {
			map_lineverts = new Array();
			gl = _context.webgl;
			window = _window;
			context = _context;
				
			mapVertexShader = gl.createShader(gl.VERTEX_SHADER);
			mapFragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
				
			gl.shaderSource(mapVertexShader, Shaders.vertext);
			gl.shaderSource(mapFragmentShader, Shaders.fragment);
			
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
		
		if (Environment.NEEDS_TO_REBUILD_AUTOMAP) {
			rebuildMapArray();
		}
		
		bindAttributes();
		
		//Move this to Automap when FPS part is done.
		
		if (Environment.IS_IN_AUTOMAP) {
			
			gl.useProgram(program);
			
			gl.clearColor (0x6c / 255, 0x54 / 255, 0x40 / 255, 0);
			gl.clear (gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
			
			automapMatrix4.appendTranslation( -Engine.ACTIVEMAP.actors_players[0].xpos, -Engine.ACTIVEMAP.actors_players[0].ypos, 0);
			automapMatrix4.appendRotation(Engine.ACTIVEMAP.actors_players[0].angle - 90, new Vector4(0, 0, -1, 1));
			automapMatrix4.appendScale(Environment.AUTOMAP_ZOOM, (Environment.AUTOMAP_ZOOM * (context.window.width / context.window.height)), 1);
			//automapMatrix4.pointAt(new Vector4(0.25, 0, 0, 1), null, new Vector4(0, 1, 1, 0));
		
			gl.uniformMatrix4fv(gl.getUniformLocation(program, Automap.M4_POSITION), false, automapFloat32);
			
			gl.lineWidth(1 / (2 / Environment.AUTOMAP_ZOOM));
			gl.drawArrays(gl.LINES, 0, Std.int(map_lineverts.length / 6));
			
		} else {
			
		}
	}
	
	function bindAttributes() 
	{
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
		
		automapFloat32 = new Float32Array(16);
		automapMatrix4 = new Matrix4(automapFloat32);
		automapMatrix4.identity();
	}
	function rebuildMapArray() {
		var loadedsegs = Engine.ACTIVEMAP.segments;
		var visSegs = Engine.ACTIVEMAP.getVisibleSegments();
		var numSegs = ((loadedsegs.length -1) * 12);
		map_lineverts.resize(numSegs);
		var itemCount:Int = 0;
		
		for (segs in 0...loadedsegs.length) {
			
			loadedsegs[segs].GLOffset = itemCount;
			
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
	
	function adjustSegmentValues(_segindex:Int, ?_startx:Float, ?_starty:Float, ?_endx:Float, ?_endy:Float, ?_startcolor:Int, ?_endcolor:Int) {
		
		var seg = Engine.ACTIVEMAP.segments[_segindex];
		var offset = seg.GLOffset;
		
		if (_startx != null) map_lineverts[offset] = _startx;
		if (_starty != null) map_lineverts[offset + 1] = _starty;
		//z coordinate [offset + 2]
		
		if (_startcolor != null) {
			map_lineverts[offset + 3] = (_startcolor >> 16) / 255;
			map_lineverts[offset + 4] = ((_startcolor >> 8) & 0xFF) / 255;
			map_lineverts[offset + 5] = (_startcolor & 0xFF) / 255;
		}
		
	}
}