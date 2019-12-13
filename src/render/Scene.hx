package render;

import lime.graphics.RenderContext;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;
import lime.graphics.opengl.GL;

import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 */
class Scene 
{
	var gl:WebGLRenderContext;
	var program:GLProgram;
	var vertShader:String = [
	'precision mediump float;',
	'attribute vec2 vertPosition;',
	'attribute vec3 vertColor;',
	'varying vec3 fragColor;',
	'',
	'void main()',
	'{',
	'	fragColor = vertColor;',
	'	gl_Position = vec4(vertPosition, 0.0, 1.0);',
	'}'
	].join('\n');
	
	var fragShader:String = [
	'precision mediump float;',
	'varying vec3 fragColor;',
	'',
	'void main()',
	'{',
	' 	gl_FragColor = vec4(fragColor, 1.0);',
	'}'
	].join('\n');
	
	
	var map_lineverts:Array<Float>;
	
	public function new(_context:RenderContext) 
	{
		if (gl == null) {
			gl = _context.webgl;
				
			var vShader = gl.createShader(gl.VERTEX_SHADER);
			var fShader = gl.createShader(gl.FRAGMENT_SHADER);
				
			gl.shaderSource(vShader, vertShader);
			gl.shaderSource(fShader, fragShader);
			
			gl.compileShader(vShader);
			gl.compileShader(fShader);
				
			program = gl.createProgram();
			gl.attachShader(program, vShader);
			gl.attachShader(program, fShader);
			gl.linkProgram(program);
		}
	}
	public function render() {
		gl.clearColor (0, 0, 0, 1);
		gl.clear (gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
		
		map_lineverts = new Array();
		var visible_segs = Engine.ACTIVEMAP.getVisibleSegments();
		
		var xoff = Engine.ACTIVEMAP.offset_x;
		var yoff = Engine.ACTIVEMAP.offset_y;
		
		for (segs in visible_segs) {
			var r:Float = 1 * Math.random();
			var g:Float = 1 * Math.random();
			var b:Float = 1 * Math.random();
			
			map_lineverts.push(segs.start.xpos + xoff);
			map_lineverts.push(segs.start.ypos + yoff);
			
			map_lineverts.push(r);
			map_lineverts.push(g);
			map_lineverts.push(b);
			
			map_lineverts.push(segs.end.xpos + xoff);
			map_lineverts.push(segs.end.ypos + yoff);
			
			map_lineverts.push(r);
			map_lineverts.push(g);
			map_lineverts.push(b);
		}
		
		var triVertBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, triVertBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(map_lineverts), gl.STATIC_DRAW);
		
		var posAttributeLocation = gl.getAttribLocation(program, 'vertPosition');
		var colorAttributeLocation = gl.getAttribLocation(program, 'vertColor');
		gl.vertexAttribPointer(
			posAttributeLocation,
			2,
			gl.FLOAT,
			false,
			5 * Float32Array.BYTES_PER_ELEMENT,
			0);
		gl.vertexAttribPointer(
			colorAttributeLocation,
			3,
			gl.FLOAT,
			false,
			5 * Float32Array.BYTES_PER_ELEMENT,
			2 * Float32Array.BYTES_PER_ELEMENT);
		gl.enableVertexAttribArray(posAttributeLocation);
		gl.enableVertexAttribArray(colorAttributeLocation);
		
		var numlines:Int = visible_segs.length * 2; //active maps number of segments
				
		gl.useProgram(program);
		gl.drawArrays(gl.LINES, 0, numlines);
	}
}