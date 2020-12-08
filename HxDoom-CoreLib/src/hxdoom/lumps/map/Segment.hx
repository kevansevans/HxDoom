package hxdoom.lumps.map;

import haxe.io.Bytes;
import hxdoom.Engine;
import hxdoom.enums.eng.SideType;
import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class Segment extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> Segment = Segment.new;
	
	public static inline var BYTE_SIZE:Int = 12;
	
	public var startID:Int;
	public var endID:Int;
	public var angle:Int;
	public var lineID:Int;
	public var side:Int;
	public var offset:Int;
	
	public var start(get, null):Vertex;
	public var end(get, null):Vertex;
	public var sector(get, null):Sector;
	public var lineDef(get, null):LineDef;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		if (override_new) return;
		
		startID = 	_args[0];
		endID = 	_args[1];
		angle = 	_args[2];
		lineID = 	_args[3];
		side = 		_args[4];
		offset = 	_args[5];
	}
	
	override public function copy():Segment
	{
		var segment = Segment.CONSTRUCTOR([
			startID,
			endID,
			angle,
			lineID,
			side,
			offset
		]);
		return segment;
	}
	
	public function get_start():Vertex 
	{
		return Engine.LEVELS.currentMap.vertexes[startID];
	}
	
	public function get_end():Vertex 
	{
		return Engine.LEVELS.currentMap.vertexes[endID];
	}
	
	public function get_sector():Sector 
	{
		if (side == 0) {
			return lineDef.frontSideDef.sector;
		} else {
			return lineDef.backSideDef.sector;
		}
	}
	
	public function get_lineDef():LineDef 
	{
		return Engine.LEVELS.currentMap.linedefs[lineID];
	}
	
	public function toString():String {
		return([
			'Angle: {' + angle + '}, ',
			'Direction: {' + (side == 0 ? '0: Front' : '1: back') + '}, ',
			'Offset: {' + offset + '}, ',
			'Sector: {' + sector + '}, '
		].join(""));
	}
	
	override public function toDataBytes():Bytes 
	{
		var bytes = Bytes.alloc(BYTE_SIZE);
		bytes.setUInt16(0, startID);
		bytes.setUInt16(2, endID);
		bytes.setUInt16(4, angle);
		bytes.setUInt16(6, lineID);
		bytes.setUInt16(8, side);
		bytes.setUInt16(10, offset);
		return bytes;
	}
	
	public static function toGLTriangles(_segment:Segment, _type:SideType):Array<Float> {
		
		var segment = _segment;
		var type = _type;
		var verts:Array<Float> = new Array();
		var texturename:String = "-";
		
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
		
		var texture = Engine.TEXTURES.getTexture(texturename);
		
		var uv_ratio_x:Float = 1;
		var uv_ratio_y:Float = 1;
		var px_ratio_x:Float = 1;
		var px_ratio_y:Float = 1;
		var px_offset_x:Float = 1;
		var px_offset_y:Float = 1;
		
		uv_ratio_y = Math.sqrt(Math.pow(segment.end.xpos - segment.start.xpos, 2) + Math.pow(segment.end.ypos - segment.start.ypos, 2)) / texture.width;
		switch (type) {
			case SOLID :
				uv_ratio_x = (segment.sector.ceilingHeight - segment.sector.floorHeight) / texture.height;
			case FRONT_TOP:
				uv_ratio_x = (segment.sector.ceilingHeight - segment.lineDef.backSideDef.sector.ceilingHeight) / texture.height;
			case FRONT_MIDDLE:
				uv_ratio_x = (segment.lineDef.backSideDef.sector.ceilingHeight - segment.lineDef.backSideDef.sector.floorHeight) / texture.height;
			case FRONT_BOTTOM :
				uv_ratio_x = (segment.lineDef.backSideDef.sector.floorHeight - segment.sector.floorHeight) / texture.height;
			case BACK_TOP :
				uv_ratio_x = (segment.lineDef.frontSideDef.sector.floorHeight - segment.sector.floorHeight) / texture.height;
			case BACK_BOTTOM :
				uv_ratio_x = (segment.lineDef.backSideDef.sector.floorHeight - segment.sector.floorHeight) / texture.height;
			default :
				uv_ratio_x = (segment.lineDef.frontSideDef.sector.ceilingHeight - segment.lineDef.frontSideDef.sector.ceilingHeight) / texture.height;
		}
		
		px_ratio_x = (1 / texture.width) * uv_ratio_x;
		px_ratio_y = (1 / texture.height) * uv_ratio_y;
		
		switch (type) {
			case SOLID | FRONT_TOP :
				px_offset_x += (px_ratio_x * segment.lineDef.frontSideDef.xoffset);
				px_offset_y += (px_ratio_y * segment.lineDef.frontSideDef.yoffset) + (px_ratio_y * segment.lineDef.frontSideDef.sector.ceilingHeight);
			case FRONT_MIDDLE :
				px_offset_x += (px_ratio_x * segment.lineDef.frontSideDef.xoffset);
				px_offset_y += (px_ratio_y * segment.lineDef.frontSideDef.yoffset) + (px_ratio_y * segment.lineDef.backSideDef.sector.ceilingHeight);
			case FRONT_BOTTOM :
				px_offset_x += (px_ratio_x * segment.lineDef.frontSideDef.xoffset);
				px_offset_y += (px_ratio_y * segment.lineDef.frontSideDef.yoffset) + (px_ratio_y * segment.lineDef.backSideDef.sector.floorHeight);
			case BACK_BOTTOM | BACK_MIDDLE | BACK_TOP :
				px_offset_x += (px_ratio_x * segment.lineDef.backSideDef.xoffset);
				px_offset_y += (px_ratio_y * segment.lineDef.backSideDef.yoffset);
		}
		
		var index = 0;
		
		switch(type) {
			
			case SOLID:
				
				verts[index] 		= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				verts[index += 1] 	= px_offset_y;
				verts[index += 1] 	= px_offset_x + uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				verts[index += 1] 	= px_offset_y + uv_ratio_y;
				verts[index += 1] 	= px_offset_x + uv_ratio_x;
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= px_offset_y;
				verts[index += 1] 	= px_offset_x;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= px_offset_y;
				verts[index += 1] 	= px_offset_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				verts[index += 1] 	= px_offset_y + uv_ratio_y;
				verts[index += 1] 	= px_offset_x + uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= px_offset_y + uv_ratio_y;
				verts[index += 1] 	= px_offset_x;
				
			case FRONT_TOP:
				
				verts[index] 		= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= px_offset_y;
				verts[index += 1] 	= px_offset_x + uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= px_offset_y + uv_ratio_y;
				verts[index += 1] 	= px_offset_x + uv_ratio_x;
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= px_offset_y;
				verts[index += 1] 	= px_offset_x;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= px_offset_y;
				verts[index += 1] 	= px_offset_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= px_offset_y + uv_ratio_y;
				verts[index += 1] 	= px_offset_x + uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= px_offset_y + uv_ratio_y;
				verts[index += 1] 	= px_offset_x;
				
			case FRONT_MIDDLE:
				
				verts[index] 		= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= 0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= 0;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= 0;
				
			case FRONT_BOTTOM:
				
				verts[index] 		= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= 0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= 0;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= 0;
				
			case BACK_TOP:
				
				verts[index] 		= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= 0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= 0;
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= 0;
				
			case BACK_MIDDLE:
				
				verts[index] 		= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= 0;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= 0;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.ceilingHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= 0;
				
			case BACK_BOTTOM:
				
				verts[index] 		= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= 0;
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= 0;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= uv_ratio_x;
				
				////////////////////////////////////////////////////////////////////////////////////////////////////
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.frontSideDef.sector.floorHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= 0;
				
				verts[index += 1] 	= segment.start.xpos;
				verts[index += 1] 	= segment.start.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= 0;
				verts[index += 1] 	= uv_ratio_x;
				
				verts[index += 1] 	= segment.end.xpos;
				verts[index += 1] 	= segment.end.ypos;
				verts[index += 1] 	= segment.lineDef.backSideDef.sector.floorHeight;
				
				verts[index += 1] 	= uv_ratio_y;
				verts[index += 1] 	= uv_ratio_x;
				
			default :
				trace("Fix me!");
		}
		
		return verts;
	}
}