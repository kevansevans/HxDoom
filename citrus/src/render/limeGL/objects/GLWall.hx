package render.limeGL.objects;

import haxe.PosInfos;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Sector;
import hxdoom.lumps.map.Segment;
import hxdoom.lumps.graphic.Patch;
import hxdoom.enums.eng.SideType;
import hxdoom.core.Reader;
import hxdoom.Engine;
import lime.graphics.ImageBuffer;
import lime.graphics.Image;
import lime.graphics.PixelFormat;
import lime.utils.UInt8Array;

import lime.graphics.opengl.GLTexture;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;

import render.limeGL.programs.GLMapGeometry;

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
	
	var texture:GLTexture;
	var textureAttribute:Int;
	var vertexAttribute:Int;
	var boxVertices:Array<Float>;
	
	var r_redcolor:Float;
	var r_grncolor:Float;
	var r_blucolor:Float;
	
	var uv_ratio_x:Float = 1;
	var uv_ratio_y:Float = 1;
	var px_ratio_x:Float = 1;
	var px_ratio_y:Float = 1;
	var px_offset_x:Float = 1;
	var px_offset_y:Float = 1;
	
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
	}
	public function render(_program:GLProgram) {
		
		if (_program == null) return;
		
		if (texturename == "-") return;
		
		if (GLMapGeometry.textureCache[texturename] == null) return;
		
		//check if wall is covered
		/*switch (type) {
			
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
		}*/
		
		var loadedLineBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, loadedLineBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(plane_vertexes), gl.STATIC_DRAW);
		
		var posAttributeLocation = gl.getAttribLocation(_program, "V3_POSITION");
		var texCoordAttribLocation = gl.getAttribLocation(_program, 'vTextureCoord');
		gl.vertexAttribPointer(
			posAttributeLocation,
			3,
			gl.FLOAT,
			false,
			5 * Float32Array.BYTES_PER_ELEMENT,
			0);
		gl.vertexAttribPointer(
			texCoordAttribLocation,
			2,
			gl.FLOAT,
			false,
			5 * Float32Array.BYTES_PER_ELEMENT,
			3 * Float32Array.BYTES_PER_ELEMENT
		);
		gl.enableVertexAttribArray(posAttributeLocation);
		gl.enableVertexAttribArray(texCoordAttribLocation);
		
		var boxIndices = [	0, 1, 
							1, 1, 
							1, 1,
							0, 1];
			
		var boxIndexBufferObject = gl.createBuffer();
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, boxIndexBufferObject);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new UInt16Array(boxIndices), gl.STATIC_DRAW);
		
		var image:Image = GLMapGeometry.textureCache[texturename].limeImage;
		
		textureAttribute = gl.getAttribLocation (_program, "aTextureCoord");
		gl.enableVertexAttribArray (textureAttribute);
		
		texture = gl.createTexture ();
		gl.bindTexture (gl.TEXTURE_2D, texture);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
		#if js
		gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image.src);
		#else
		gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, image.buffer.width, image.buffer.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, image.data);
		#end
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
		
		gl.vertexAttribPointer (textureAttribute, 2, gl.FLOAT, false, 4 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		
		if (plane_vertexes == null) return;
		
		switch (type) {
			case SOLID | FRONT_TOP | FRONT_MIDDLE | FRONT_BOTTOM :
				gl.cullFace(gl.BACK);
			case BACK_BOTTOM | BACK_MIDDLE | BACK_TOP :
				gl.cullFace(gl.FRONT);
		}
		
		gl.drawArrays(gl.TRIANGLES, 0, Std.int(plane_vertexes.length / 5));
	}
	
	function isPowerOf2(value:Int) {
		return (value & (value - 1)) == 0;
	}
	
	function buildVertexes(_type:SideType) {
		
		switch (_type) {
			case SOLID :
				texturename = segment.lineDef.frontSideDef.middle_texture;
			case FRONT_BOTTOM :
				texturename = segment.lineDef.frontSideDef.lower_texture;
			case FRONT_MIDDLE :
				texturename = segment.lineDef.frontSideDef.middle_texture;
			case FRONT_TOP :
				texturename = segment.lineDef.frontSideDef.upper_texture;
			case BACK_BOTTOM :
				texturename = segment.lineDef.backSideDef.lower_texture;
			case BACK_MIDDLE :
				texturename = segment.lineDef.backSideDef.middle_texture;
			case BACK_TOP :
				texturename = segment.lineDef.backSideDef.upper_texture;
		}
		
		if (texturename == "-") return;
		
		//This switch block is a placeholder and only used for testing
		switch(texturename) {
			case "AASTINKY" :
				texturename = "-";
			case "BIGDOOR2" :
				texturename = "DOOR2_4";
			case "STARGR1" :
				texturename = "SW11_1";
			case "LITE3" :
				texturename = "WLITB0";
			case "COMPUTE2" :
				texturename = "COMP02_7";
			case "COMPSPAN" :
				texturename = "COMP03_4";
			case "COMPTALL" :
				texturename = "COMP04_5";
			case "STARTAN3" :
				texturename = "SW19_1";
			case "STEP6" :
				texturename = "STEP03";
			case "DOORTRAK" :
				texturename = "DOORTRAK";
			case "SUPPORT2" :
				texturename = "SUPPORT2";
			case "STEP1" :
				texturename = "STEP04";
			case "COMPTILE" :
				texturename = "COMP03_1";
			case "PLANET1" :
				texturename = "TSCRN2";
			case "BROWN144" :
				texturename = "WALL04_7";
			case "DOORSTOP" :
				texturename = "TTALL1_2";
			case "BROWN1" :
				texturename = "WALL05_2";
			case "SLADWALL" :
				texturename = "WLA128_1";
			case "STARG3" :
				texturename = "SW12_2";
			case "TEKWALL4" :
				texturename = "W94_1";
			case "TEKWALL1" :
				texturename = "W17_1";
			case "BROWNGRN" :
				texturename = "WALL62_2";
			case "NUKE24" :
				texturename = "NUKEDGE";
			case "DOOR3" :
				texturename = "DOOR2_5";
			case "BROWN96" :
				texturename = "WALL62_1";
			case "BRNBIGL" :
				texturename = "W113_2";
			case "BRNBIGR" :
				texturename = "W113_3";
			case "BRNBIGC" :
				texturename = "W113_1";
			case "BIGDOOR4" :
				texturename = "DOOR9_1";
			case "STARTAN1" :
				texturename = "SW12_4";
			case "EXITSIGN" :
				texturename = "EXIT1";
			case "EXITDOOR" :
				texturename = "DOOR3_6";
			case "SW1STRTN" :
				texturename = "SW1S0";
			case "COMPSTA1" :
				texturename = "COMP02_6";
			case "GRAYTALL" :
				texturename = "W31_1";
			case "COMPSTA2" :
				texturename = "COMP02_4";
			case "STARTAN2" :
				texturename = "SW17_6";
			case "STEP5" :
				texturename = "STEP09";
			case "METAL1" :
				texturename = "STFOUCH0";
			case "STONE2" :
				texturename = "W28_5";
			case "STEP3" :
				texturename = "STEP05";
			case "STONE3" :
				texturename = "W28_6";
			case "TEKWALL2" :
				texturename = "WALL24_1";
			default :
				trace(texturename);
				texturename = "STFOUCH0";
			
		}
			
		if (GLMapGeometry.textureCache[texturename] == null) {
		
			var _locPatch:Patch = Engine.WADDATA.getPatch(texturename);
			var playpal = Engine.WADDATA.playpal;
			
			var arr:Array<Int> = new Array();
			
			var w:Int = 0;
			var h:Int = 0;
			
			while (true) {
				arr.push(playpal.getColorChannelInt(_locPatch.pixels[w][h], 0));
				arr.push(playpal.getColorChannelInt(_locPatch.pixels[w][h], 1));
				arr.push(playpal.getColorChannelInt(_locPatch.pixels[w][h], 2));
				arr.push(playpal.getColorChannelInt(_locPatch.pixels[w][h], 3));
				
				++w;
				if (w >= _locPatch.width) {
					w = 0;
					++h;
					if (h >= _locPatch.height) break;
				}
			}
			var image:Image = new Image(
				new ImageBuffer(
					new UInt8Array(arr), 
					_locPatch.width, 
					_locPatch.height, 
					32, 
					PixelFormat.RGBA32)
				);
			image.buffer.transparent = true;
			
				var tex:TexData = {
				name : texturename,
				glIndex : GLMapGeometry.glTextureIndex,
				limeImage : image,
				patch : _locPatch
			};
			
			GLMapGeometry.textureCache[texturename] = tex;
			
			++GLMapGeometry.glTextureIndex;
		}
		
		uv_ratio_y = Math.sqrt(Math.pow(segment.end.xpos - segment.start.xpos, 2) + Math.pow(segment.end.ypos - segment.start.ypos, 2)) / GLMapGeometry.textureCache[texturename].patch.width;
		switch (type) {
			case SOLID :
				uv_ratio_x = (segment.sector.ceilingHeight - segment.sector.floorHeight) / GLMapGeometry.textureCache[texturename].patch.height;
			case FRONT_TOP:
				uv_ratio_x = (segment.sector.ceilingHeight - segment.lineDef.backSideDef.sector.ceilingHeight) / GLMapGeometry.textureCache[texturename].patch.height;
			case FRONT_MIDDLE:
				uv_ratio_x = (segment.lineDef.backSideDef.sector.ceilingHeight - segment.lineDef.backSideDef.sector.floorHeight) / GLMapGeometry.textureCache[texturename].patch.height;
			case FRONT_BOTTOM :
				uv_ratio_x = (segment.lineDef.backSideDef.sector.floorHeight - segment.sector.floorHeight) / GLMapGeometry.textureCache[texturename].patch.height;
			case BACK_TOP :
				uv_ratio_x = (segment.lineDef.frontSideDef.sector.floorHeight - segment.sector.floorHeight) / GLMapGeometry.textureCache[texturename].patch.height;
			case BACK_BOTTOM :
				uv_ratio_x = (segment.lineDef.backSideDef.sector.floorHeight - segment.sector.floorHeight) / GLMapGeometry.textureCache[texturename].patch.height;
			default :
				uv_ratio_x = (segment.lineDef.frontSideDef.sector.ceilingHeight - segment.lineDef.frontSideDef.sector.ceilingHeight) / GLMapGeometry.textureCache[texturename].patch.height;
		}
		
		px_ratio_x = (1 / GLMapGeometry.textureCache[texturename].patch.width) * uv_ratio_x;
		px_ratio_y = (1 / GLMapGeometry.textureCache[texturename].patch.height) * uv_ratio_y;
		
		px_offset_y = px_ratio_x * GLMapGeometry.textureCache[texturename].patch.offset_x;
		px_offset_x = px_ratio_y * GLMapGeometry.textureCache[texturename].patch.offset_y;
		
		switch (type) {
			case SOLID | FRONT_BOTTOM | FRONT_MIDDLE | FRONT_TOP :
				px_offset_x += (px_ratio_x *  segment.lineDef.frontSideDef.xoffset);
				px_offset_y += (px_ratio_y *  segment.lineDef.frontSideDef.yoffset);
			case BACK_BOTTOM | BACK_MIDDLE | BACK_TOP :
				px_offset_x += (px_ratio_x *  segment.lineDef.backSideDef.xoffset);
				px_offset_y += (px_ratio_y *  segment.lineDef.backSideDef.yoffset);
		}
		
		var index = 0;
		
		switch(_type) {
			
			case SOLID:
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y;
				plane_vertexes[index += 1] 	= px_offset_x + uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y + uv_ratio_y;
				plane_vertexes[index += 1] 	= px_offset_x + uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y;
				plane_vertexes[index += 1] 	= px_offset_x;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y;
				plane_vertexes[index += 1] 	= px_offset_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y + uv_ratio_y;
				plane_vertexes[index += 1] 	= px_offset_x + uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y + uv_ratio_y;
				plane_vertexes[index += 1] 	= px_offset_x;
				
			case FRONT_TOP:
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y;
				plane_vertexes[index += 1] 	= px_offset_x + uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y + uv_ratio_y;
				plane_vertexes[index += 1] 	= px_offset_x + uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y;
				plane_vertexes[index += 1] 	= px_offset_x;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y;
				plane_vertexes[index += 1] 	= px_offset_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y + uv_ratio_y;
				plane_vertexes[index += 1] 	= px_offset_x + uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= px_offset_y + uv_ratio_y;
				plane_vertexes[index += 1] 	= px_offset_x;
				
			case FRONT_MIDDLE:
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= 0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= 0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= 0;
				
			case FRONT_BOTTOM:
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= 0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= 0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= 0;
				
			case BACK_TOP:
				
				plane_vertexes[index] 		= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= 0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= 0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= 0;
				
			case BACK_MIDDLE:
				
				plane_vertexes[index] 		= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= 0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= 0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= 0;
				
			case BACK_BOTTOM:
				
				plane_vertexes[index] 		= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= 0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= 0;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= 0;
				
				plane_vertexes[index += 1] 	= segment.start.xpos;
				plane_vertexes[index += 1] 	= segment.start.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= 0;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
				plane_vertexes[index += 1] 	= segment.end.xpos;
				plane_vertexes[index += 1] 	= segment.end.ypos;
				plane_vertexes[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				plane_vertexes[index += 1] 	= uv_ratio_y;
				plane_vertexes[index += 1] 	= uv_ratio_x;
				
			default :
				trace("Fix me!");
		}
	}
}