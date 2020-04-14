package render.citrusGL.objects;

import hxdoom.lumps.map.Segment;
import hxdoom.lumps.map.SubSector;
import hxdoom.Engine;
import hxdoom.lumps.map.Vertex;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;

enum FlatType {
	FLOOR;
	CEILING;
}

/**
 * ...
 * @author Kaelan
 */
class GLFlat 
{
	var gl:WebGLRenderContext;
	var planeheight:Int = 0;
	var subsector:SubSector;
	var plane_vertexes:Array<Float>;
	var type:FlatType;
	var texturename:String;
	
	public function new(_context:WebGLRenderContext, _subsector:SubSector, _type:FlatType) 
	{
		gl = _context;
		subsector = _subsector;
		type = _type;
		
		buildPlane();
	}
	function buildPlane() {
		
		plane_vertexes = new Array();
		
		var segs:Array<Segment> = new Array();
		for (seg in subsector.firstSegID...(subsector.count + subsector.firstSegID)) {
			segs.push(Engine.ACTIVEMAP.segments[seg]);
		}
		
		switch (type) {
			case FLOOR :
				//segs.reverse();
				planeheight = subsector.sector.floorHeight;
				texturename = subsector.sector.floorTexture;
			case CEILING :
				planeheight = subsector.sector.ceilingHeight;
				texturename = subsector.sector.ceilingTexture;
			default :
				trace("What in the god damn hell did you do to accomplish this!?");
		}
		
		return;
		
	}
	
	public function render(_program:GLProgram) {
		
		return;
		
		if (texturename == "-") return;
		
		switch (type) {
			case FLOOR :
				if (planeheight > Engine.ACTIVEMAP.actors_players[0].zpos) return;
				
			case CEILING :
				if (planeheight > Engine.ACTIVEMAP.actors_players[0].zpos) return;
		}
		
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