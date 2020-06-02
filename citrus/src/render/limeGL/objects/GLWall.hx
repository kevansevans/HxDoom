package render.limeGL.objects;

import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Sector;
import hxdoom.lumps.map.Segment;
import hxdoom.lumps.graphic.Patch;
import hxdoom.utils.enums.SideType;
import hxdoom.core.Reader;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;

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
	var texturename:String;
	var patch:Patch;
	
	var r_redcolor:Float;
	var r_grncolor:Float;
	var r_blucolor:Float;
	
	public function new(_context:WebGLRenderContext, _segment:Segment, _type:SideType) 
	{
		gl = _context;
		segment = _segment;
		type = _type;
		
		plane_vertexes = new Array();
		plane_vertexes.resize(42);
		
		r_redcolor = Math.random();
		r_grncolor = Math.random();
		r_blucolor = Math.random();
		
		buildVertexes(_type);
		buildTextureMap(_segment.lineDef);
	}
	public function render(_program:GLProgram) {
		
		if (_program == null) return;
		
		if (texturename == "-") return;
		
		//check if wall is covered
		switch (type) {
			
			case SOLID :
				if (segment.lineDef.frontSideDef.sector.floorHeight == segment.lineDef.frontSideDef.sector.ceilingHeight) {
					return;
				}
			case FRONT_BOTTOM :
				if (segment.lineDef.frontSideDef.sector.floorHeight >= segment.lineDef.backSideDef.sector.floorHeight) {
					return;
				}
			case FRONT_TOP :
				if (segment.lineDef.frontSideDef.sector.ceilingHeight <= segment.lineDef.backSideDef.sector.ceilingHeight) {
					return;
				}
			case FRONT_MIDDLE | BACK_MIDDLE :
				if (segment.lineDef.frontSideDef.sector.floorHeight == segment.lineDef.frontSideDef.sector.ceilingHeight || segment.lineDef.backSideDef.sector.floorHeight == segment.lineDef.backSideDef.sector.ceilingHeight) {
					return;
				}
			default :
		}
		
		var loadedLineBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, loadedLineBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(plane_vertexes), gl.STATIC_DRAW);
		
		var posAttributeLocation:Null<Int> = gl.getAttribLocation(_program, "V3_POSITION");
		
		if (posAttributeLocation == null) return;
		
		gl.vertexAttribPointer(
			posAttributeLocation,
			3,
			gl.FLOAT,
			false,
			3 * Float32Array.BYTES_PER_ELEMENT,
			0);
		gl.enableVertexAttribArray(posAttributeLocation);
		
		gl.useProgram(_program);
		
		if (plane_vertexes == null) return;
		gl.drawArrays(gl.TRIANGLES, 0, Std.int(plane_vertexes.length / 3));
	}
	
	public function buildTextureMap(lineDef:hxdoom.lumps.map.LineDef) 
	{
	//	Eng
	}
	
	function buildVertexes(_type:SideType) {
		
		var index = 0;
		
		switch(_type) {
			
			case SOLID:
				
				texturename = segment.lineDef.frontSideDef.middle_texture;
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
			case FRONT_TOP:
				
				texturename = segment.lineDef.frontSideDef.upper_texture;
				
				plane_vertexes[index] 		= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
			case FRONT_MIDDLE:
				
				texturename = segment.lineDef.frontSideDef.middle_texture;
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
			case FRONT_BOTTOM:
				
				texturename = segment.lineDef.frontSideDef.lower_texture;
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
			case BACK_TOP:
				
				texturename = segment.lineDef.backSideDef.upper_texture;
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
			case BACK_MIDDLE:
				
				texturename = segment.lineDef.backSideDef.middle_texture;
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
			case BACK_BOTTOM:
				
				texturename = segment.lineDef.backSideDef.lower_texture;
				
				plane_vertexes[index] 		= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
			default :
				trace("Fix me!");
		}
	}
	
}