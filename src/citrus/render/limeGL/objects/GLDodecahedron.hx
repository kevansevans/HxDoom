package citrus.render.limeGL.objects;

import hxdoom.actors.Actor;
import hxdoom.lumps.map.Segment;
import hxdoom.lumps.map.SubSector;
import hxdoom.Engine;
import hxdoom.lumps.map.Thing;
import hxdoom.lumps.map.Vertex;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;

/**
 * ...
 * @author Kaelan
 */
class GLDodecahedron 
{
	var gl:WebGLRenderContext;
	var plane_vertexes:Array<Float>;
	//var object_vertexes
	var radius:Float = Math.sqrt(3) * 10;
	var actor:Actor;

	public function new(_context:WebGLRenderContext, _actor:Actor) 
	{
		gl = _context;
		
		actor = _actor;
		
		plane_vertexes = new Array();
		
		var phi:Float = (Math.sqrt(5) - 1) / 2;
		
		var a:Float = 1 / Math.sqrt(3);
		var b:Float = a / phi;
		var c:Float = a * phi;
		
		var r_red = Math.random();
		var r_grn = Math.random();
		var r_blu = Math.random();
		
		for (i in [ -1, 1]) {
			
			for (j in [ -1, 1]) {
				
				plane_vertexes.push(actor.xpos);
				plane_vertexes.push((i * c * radius) + actor.ypos);
				plane_vertexes.push((j * b * radius) + actor.zpos);
				
				plane_vertexes.push(r_red);
				plane_vertexes.push(r_grn);
				plane_vertexes.push(r_blu);
				plane_vertexes.push(1);
				
				plane_vertexes.push((i * c * radius) + actor.xpos);
				plane_vertexes.push((j * b * radius) + actor.ypos);
				plane_vertexes.push(actor.zpos);
				
				plane_vertexes.push(r_red);
				plane_vertexes.push(r_grn);
				plane_vertexes.push(r_blu);
				plane_vertexes.push(1);
				
				plane_vertexes.push((i * c * radius) + actor.xpos);
				plane_vertexes.push(actor.ypos);
				plane_vertexes.push((j * b * radius) + actor.zpos);
				
				plane_vertexes.push(r_red);
				plane_vertexes.push(r_grn);
				plane_vertexes.push(r_blu);
				plane_vertexes.push(1);
				
				for (k in [ -1, 1]) {
					plane_vertexes.push((i * a * radius) + actor.xpos);
					plane_vertexes.push((j * a * radius) + actor.ypos);
					plane_vertexes.push((k * a * radius) + actor.zpos);
				
					plane_vertexes.push(r_red);
					plane_vertexes.push(r_grn);
					plane_vertexes.push(r_blu);
					plane_vertexes.push(255);
				}
			}
		}
	}
	
	public function render(_program:GLProgram) {
		
		var loadedLineBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, loadedLineBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(plane_vertexes), gl.STATIC_DRAW);
		
		var posAttributeLocation:Null<Int> = gl.getAttribLocation(_program, "V3_POSITION");
		var colorAttributeLocation:Null<Int> = gl.getAttribLocation(_program, "V4_COLOR");
		
		if (posAttributeLocation == null || colorAttributeLocation == null) return;
		
		gl.vertexAttribPointer(
			posAttributeLocation,
			3,
			gl.FLOAT,
			false,
			7 * Float32Array.BYTES_PER_ELEMENT,
			0);
		gl.vertexAttribPointer(
			colorAttributeLocation,
			4,
			gl.FLOAT,
			false,
			7 * Float32Array.BYTES_PER_ELEMENT,
			3 * Float32Array.BYTES_PER_ELEMENT);
		gl.enableVertexAttribArray(posAttributeLocation);
		gl.enableVertexAttribArray(colorAttributeLocation);
		
		gl.useProgram(_program);
		
		if (plane_vertexes == null) return;
		gl.drawArrays(gl.TRIANGLE_FAN, 0, Std.int(plane_vertexes.length / 7));
	}
	
}