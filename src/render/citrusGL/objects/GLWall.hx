package render.citrusGL.objects;

import hxdoom.lumps.map.Segment;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;

enum SideType {
	FRONT_TOP;
	FRONT_BOTTOM;
	FRONT_MIDDLE;
	BACK_TOP;
	BACK_BOTTOM;
	BACK_MIDDLE;
	SOLID;
}

/**
 * ...
 * @author Kaelan
 */
class GLWall 
{
	var gl:WebGLRenderContext;
	var plane_vertexes:Array<Float>;
	var segment:Segment;
	var type:SideType;
	
	public function new(_context:WebGLRenderContext, _segment:Segment, _type:SideType) 
	{
		gl = _context;
		segment = _segment;
		type = _type;
		
		var index = 0;
		
		plane_vertexes = new Array();
		plane_vertexes.resize(42);
		
		switch(_type) {
			
			case SOLID:
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
			case FRONT_TOP:
				
				plane_vertexes[index] 		= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
			case FRONT_MIDDLE:
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
			case FRONT_BOTTOM:
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.backSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.frontSector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.r_color;
				plane_vertexes[index += 1] 	= segment.g_color;
				plane_vertexes[index += 1] 	= segment.b_color;
				plane_vertexes[index += 1] 	= 1.0;
				
			case BACK_TOP:
				
			case BACK_MIDDLE:
				
			case BACK_BOTTOM:
		}
	}
	public function bind(_program:GLProgram) {
		
		if (plane_vertexes == null) return;
		
		if (!segment.visible) return;
		
		var loadedLineBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, loadedLineBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(plane_vertexes), gl.STATIC_DRAW);
		
		var posAttributeLocation = gl.getAttribLocation(_program, "V3_POSITION");
		var colorAttributeLocation = gl.getAttribLocation(_program, "V4_COLOR");
		
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
	}
	public function render() {
		if (plane_vertexes == null) return;
		gl.drawArrays(gl.TRIANGLES, 0, Std.int(plane_vertexes.length / 7));
	}
	
}