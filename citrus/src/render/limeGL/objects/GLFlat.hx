package render.limeGL.objects;

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
	var seg_id : Int;
	var start : Vertex;
	var end : Vertex;
	@:optional var next : Array<VertexPair>;
	//Prev pair is only needed to isolate lines that do not go anywhere. See MAP30 of DOOOM2.WAD
	@:optional var prev : Array<VertexPair>;
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
						seg_id : segment.lineID,
						start : segment.start,
						end : segment.end
					}
					//avoid duplicates that cause endless loop
					for (pair in vertpairs) {
						if (pair.seg_id == vertpair.seg_id) return;
					}
					vertpairs.push(vertpair);
				case 1 :
					var vertpair = {
						seg_id : segment.lineID,
						start : segment.end,
						end : segment.start
					}
					//avoid duplicates that cause endless loop
					for (pair in vertpairs) {
						if (pair.seg_id == vertpair.seg_id) return;
					}
					vertpairs.push(vertpair);
			}
		}
		
		//create an elaborate game of connect the dots
		for (pair_a in vertpairs) {
			
			for (pair_b in vertpairs) {
				
				//avoid indexing the same segments if by some sheer coincidence that happens
				if (pair_a == pair_b) continue;
				
				if (pair_a.end == pair_b.start) {
					if (pair_a.next == null) pair_a.next = new Array();
					pair_a.next.push(pair_b);
					if (pair_b.prev == null) pair_b.prev = new Array();
					pair_b.prev.push(pair_a);
				}
				if (pair_a.start == pair_b.end) {
					if (pair_a.prev == null) pair_a.prev = new Array();
					pair_a.prev.push(pair_b);
					if (pair_b.next == null) pair_b.next = new Array();
					pair_b.next.push(pair_a);
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
		}
		
		/*
		 * Play Elaborate game of connect the dots
		 */
		
		var shells:Array<Array<Vertex>> = new Array();
		var shell_index:Int = 0;
		var startpair = vertpairs[0];
		var workpair = vertpairs[0];
		var loopclosed:Bool = false;
		var kill_list:Array<VertexPair> = new Array();
		
		shells[0] = new Array();
		shells[0].push(startpair.start);
		shells[0].push(startpair.end);
		
		kill_list.push(startpair);
		
		while (true) {
			
			if (workpair == startpair) {
				if (startpair.next.length == 1) {
					kill_list.push(startpair);
					workpair = startpair.next[0];
				} else {
					var mostleft:Float = Math.POSITIVE_INFINITY;
					for (pair in startpair.next) {
						if (pair.end.xpos < mostleft) {
							mostleft = pair.end.xpos;
							workpair = pair;
						}
						startpair.next.remove(workpair);
					}
				}
			}
			
			if (workpair.end == startpair.start) {
				kill_list.push(workpair);
				loopclosed = true;
			} else {
				shells[shell_index].push(workpair.end);
				kill_list.push(workpair);
				if (workpair.next.length > 1) {
					var mostleft:Float = Math.POSITIVE_INFINITY;
					var prevpair = workpair;
					for (pair in workpair.next) {
						if (pair.end.xpos < mostleft) {
							mostleft = pair.end.xpos;
							workpair = pair;
						}
						prevpair.next.remove(workpair);
					}
				} else {
					workpair = workpair.next[0];
				}
			}
			
			if (loopclosed) {
				
				for (pair in kill_list) {
					
					vertpairs.remove(pair);
					
				}
				
				kill_list = new Array();
				
				if (vertpairs.length == 0) {
					
					break;
					
				} else {
					
					loopclosed = false;
					shell_index += 1;
					shells[shell_index] = new Array();
					startpair = vertpairs[0];
					workpair = vertpairs[0];
				}
			}
		}
		
		earClip(shells);
	}
	
	function earClip(_shells:Array<Array<Vertex>>) {
		
		plane_vertexes = new Array();
		
		for (shell in _shells) {
			for (vert in shell) {
				plane_vertexes.push(vert.xpos);
				plane_vertexes.push(vert.ypos);
				switch (type) {
					case FLOOR :
						plane_vertexes.push(segments[0].sector.floorHeight);
					case CEILING :
						plane_vertexes.push(segments[0].sector.ceilingHeight);
				}
				
				plane_vertexes.push(r_redcolor);
				plane_vertexes.push(r_grncolor);
				plane_vertexes.push(r_blucolor);
				plane_vertexes.push(1.0);
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
		gl.drawArrays(gl.LINE_LOOP, 0, Std.int(plane_vertexes.length / 7));
	}
}