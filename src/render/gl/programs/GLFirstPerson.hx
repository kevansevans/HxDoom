package render.gl.programs;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.utils.Float32Array;
import mme.math.glmatrix.Mat4Tools;

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
	
	var map_lineverts:Array<Float>;
	
	public function new(_gl:WebGLRenderContext)
	{
		gl = _gl;
		program = gl.createProgram();
		map_lineverts = new Array();
		
		vertex_shader = gl.createShader(gl.VERTEX_SHADER);
		fragment_shader = gl.createShader(gl.FRAGMENT_SHADER);
				
		gl.shaderSource(vertex_shader, GLFirstPerson.vertex_source);
		gl.shaderSource(fragment_shader, GLFirstPerson.fragment_source);
		
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
		
		gl.useProgram(program);
			
		gl.clearColor (0, 0, 0, 1);
		gl.clear (gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
		
		var worldArray = new Float32Array(16);
		var viewArray = new Float32Array(16);
		var projArray = new Float32Array(16);
		
		var p_subsector = Engine.ACTIVEMAP.getPlayerSector();
		var p_sectorfloor = p_subsector.segments[0].sector.floorHeight + Environment.PLAYER_VIEW_HEIGHT;
		
		Mat4Tools.identity(worldArray);
		Mat4Tools.lookAt(	[Engine.ACTIVEMAP.actors_players[0].xpos, Engine.ACTIVEMAP.actors_players[0].ypos, p_sectorfloor], 
							[Engine.ACTIVEMAP.actors_players[0].xpos_look, Engine.ACTIVEMAP.actors_players[0].ypos_look, p_sectorfloor + Engine.ACTIVEMAP.actors_players[0].zpos_look], 
							[0, 0, 1], viewArray);
		Mat4Tools.perspective(45 * (Math.PI / 180), _winWidth / _winHeight, 0.1, 10000, projArray);
		
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_World"), false, worldArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_View"), false, viewArray);
		gl.uniformMatrix4fv(gl.getUniformLocation(program, "M4_Proj"), false, projArray);
		
		gl.drawArrays(gl.TRIANGLES, 0, Std.int(map_lineverts.length / 6));
	}
	
	function rebuildMapArray() {
		
		var loadedsegs = Engine.ACTIVEMAP.getVisibleSegments();
		var sectors = Engine.ACTIVEMAP.sectors;
		var visSegs = Engine.ACTIVEMAP.getVisibleSegments();
		var numSegs = ((loadedsegs.length -1) * 36);
		map_lineverts.resize(numSegs);
		var itemCount:Int = 0;
		
		for (segs in loadedsegs) {
			var midpoint_x = (segs.lineDef.start.xpos + segs.lineDef.end.xpos) / 2;
			var midpoint_y = (segs.lineDef.start.ypos + segs.lineDef.end.ypos) / 2;
			var mid_dist = Math.sqrt(Math.pow(midpoint_x - Engine.ACTIVEMAP.actors_players[0].xpos, 2) + Math.pow(midpoint_y - Engine.ACTIVEMAP.actors_players[0].ypos, 2));
			var start_dist = Math.sqrt(Math.pow(segs.lineDef.start.xpos - Engine.ACTIVEMAP.actors_players[0].xpos, 2) + Math.pow(segs.lineDef.start.ypos - Engine.ACTIVEMAP.actors_players[0].ypos, 2));
			var end_dist = Math.sqrt(Math.pow(segs.lineDef.end.xpos - Engine.ACTIVEMAP.actors_players[0].xpos, 2) + Math.pow(segs.lineDef.end.ypos - Engine.ACTIVEMAP.actors_players[0].ypos, 2));
			var closest = Math.min(Math.min(start_dist, end_dist), mid_dist);
			segs.distFromPlayer = Std.int(closest);
		}
		
		loadedsegs.sort(function(a, b):Int {
           if(a.distFromPlayer > b.distFromPlayer) return -1;
           else if(a.distFromPlayer < b.distFromPlayer) return 1;
           else return 0;
        });
		
		for (segs in 0...loadedsegs.length) {
			
			if (loadedsegs[segs].lineDef.backSideDef != null) continue;
			
			map_lineverts[itemCount] 		= loadedsegs[segs].start.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].sector.floorHeight;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].sector.floorHeight;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].sector.ceilingHeight;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
			
			////////////////////////////////////////////////////////////////////////////////////////////////////
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].start.ypos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].sector.ceilingHeight;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].sector.ceilingHeight;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.xpos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].end.ypos;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].sector.floorHeight;
			
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].r_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].g_color;
			map_lineverts[itemCount += 1] 	= loadedsegs[segs].b_color;
			
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