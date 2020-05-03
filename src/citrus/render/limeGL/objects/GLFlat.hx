package citrus.render.limeGL.objects;

import hxdoom.lumps.map.Segment;
import hxdoom.lumps.map.SubSector;
import hxdoom.Engine;
import hxdoom.lumps.map.Vertex;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;

/**
 * ...
 * @author Kaelan
 */

enum FlatType {
	FLOOR;
	CEILING;
}

typedef VertexPair = {
	var start : Vertex;
	var end : Vertex;
	@:optional var next : VertexPair;
	@:optional var prev : VertexPair;
}

class GLFlat 
{
	var gl:WebGLRenderContext;
	var planeheight:Int = 0;
	var plane_vertexes:Array<Float>;
	var type:FlatType;
	var texturename:String;
	var segments:Array<Segment>;
	var vertpairs:Array<VertexPair>;
	
	var r_redcolor:Float;
	var r_grncolor:Float;
	var r_blucolor:Float;
	
	public function new(_context:WebGLRenderContext, _type:FlatType) 
	{
		gl = _context;
		type = _type;
		
		segments = new Array();
		vertpairs = new Array();
		
		r_redcolor = Math.random();
		r_grncolor = Math.random();
		r_blucolor = Math.random();
	}
	
	public function addSegment(_segment:Segment) {
		segments.push(_segment);
	}
	
	public function buildShells() {
		
		switch (type) {
			case FLOOR :
				planeheight = segments[0].sector.floorHeight;
			case CEILING :
				planeheight = segments[0].sector.ceilingHeight;
		}
		
		//build vertex pairs
		for (segment in segments) {
			switch (segment.side) {
				case 0:
					var vertpair = {
						start : segment.start,
						end : segment.end
					}
					vertpairs.push(vertpair);
				case 1 :
					var vertpair = {
						start : segment.end,
						end : segment.start
					}
					vertpairs.push(vertpair);
			}
		}
		
		//create an elaborate game of connect the dots
		for (pair_a in vertpairs) {
			
			if (pair_a.next != null && pair_a.prev != null) continue;
			
			for (pair_b in vertpairs) {
				if (pair_a.next == null) {
					if (pair_a.end == pair_b.start) {
						pair_a.next = pair_b;
						pair_b.prev = pair_a;
					}
				}
				if (pair_a.prev == null) {
					if (pair_a.start == pair_b.end) {
						pair_a.prev = pair_b;
						pair_b.next = pair_a;
					}
				}
			}
		}
		
		/*
		 * Remove any pairs that do not connect to another line.
		 * MAP30 of Doom 2 is a good example, there's a stray segment in the bottom right of the map
		 * if one end is null, we follow back until we get to the other broken end and close that loop.
		 */
		for (pair in vertpairs) {
			if (pair.next == null && pair.prev == null) {
				vertpairs.remove(pair);
			}
			/*to do: loop closing*/
			if (pair.next == null) {
				trace("Uh oh!");
			}
			if (pair.prev == null) {
				trace("Spaghettio!");
			}
			
			if (pair.prev == pair || pair.next == pair) {
				trace("Oh now you really dun goofed");
			}
		}
		
		//play the elaborate game of connect the dots
		var shells:Array<Array<Vertex>> = new Array();
		var index:Int = 0;
		var startpair:VertexPair = vertpairs[0];
		var workpair:VertexPair = startpair.next;
		
		shells[index] = new Array();
		shells[index].push(startpair.start);
		shells[index].push(startpair.end);
		
		/*while (true) {
			
		}*/
	}
	
	function earClip(_shells:Array<Array<Vertex>>) {
		var temp_vertexes:Array<Vertex> = new Array();
	}
	
	public function render(_program:GLProgram) {
		
		if (texturename == "-") return;
		if (plane_vertexes == null) return;
		if (plane_vertexes.length == 0) return;
		
		switch (type) {
			case FLOOR :
				if (planeheight > Engine.ACTIVEMAP.actors_players[0].zpos + 41) return;
				
			case CEILING :
				if (planeheight < Engine.ACTIVEMAP.actors_players[0].zpos + 41) return;
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