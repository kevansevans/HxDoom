package hxdoom.lumps.map;

import haxe.io.Bytes;
import hxdoom.Engine;
import hxdoom.lumps.LumpBase;

import hxdoom.component.Texture;
import hxdoom.typedefs.properties.LineDefFlags;
import hxdoom.enums.eng.SideType;

/**
 * ...
 * @author Kaelan
 */
class LineDef extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> LineDef = LineDef.new;
	
	public static var BYTE_SIZE:Int = 14;
	
	public var startVertexID:Int;
	public var endVertexID:Int;
	public var flags:LineDefFlags;
	public var special:Int;
	public var sectorTag:Int;
	public var backSideDefID:Int;
	public var frontSideDefID:Int;
	
	public var dx(get, null):Float;
	public var dy(get, null):Float;
	
	public var solid(get, null):Bool;
	
	public var frontSideDef(get, null):SideDef;
	public var backSideDef(get, null):SideDef;
	public var start(get, null):Vertex;
	public var end(get, null):Vertex;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		if (override_new) return;
		
		startVertexID = 	_args[0];
		endVertexID = 		_args[1];
		setFlags(			_args[2]);
		special = 			_args[3];
		sectorTag = 		_args[4];
		frontSideDefID = 	_args[5];
		backSideDefID = 	_args[6];
	}
	
	public function setFlags(_bits:Int) {
		flags = {};
		flags.blocking = 		(_bits & 1) > 0;
		flags.blockMonsters = 	(_bits & 2) > 0;
		flags.twoSided = 		(_bits & 4) > 0;
		flags.dontPegTop = 		(_bits & 8) > 0;
		flags.dontPegBottom = 	(_bits & 16) > 0;
		flags.secret = 			(_bits & 32) > 0;
		flags.soundBlock = 		(_bits & 64) > 0;
		flags.dontDraw = 		(_bits & 128) > 0;
		flags.mapped = 			(_bits & 256) > 0;
	}
	
	public function flagsToBits():Int {
		var bits = 0;
		if (flags.blocking) 		bits |= 1;
		if (flags.blockMonsters)	bits |= 2;
		if (flags.twoSided) 		bits |= 4;
		if (flags.dontPegTop) 		bits |= 8;
		if (flags.dontPegBottom) 	bits |= 16;
		if (flags.secret) 			bits |= 32;
		if (flags.soundBlock) 		bits |= 64;
		if (flags.dontDraw) 		bits |= 128;
		if (flags.mapped) 			bits |= 256;
		return bits;
	}
	
	public function getTexture(_side:SideType):Texture {
		switch(_side) {
			case SOLID :
				return Engine.TEXTURES.getTexture(frontSideDef.middle_texture);
			case FRONT_TOP :
				return Engine.TEXTURES.getTexture(frontSideDef.upper_texture);
			case FRONT_MIDDLE :
				return Engine.TEXTURES.getTexture(frontSideDef.middle_texture);
			case FRONT_BOTTOM :
				return Engine.TEXTURES.getTexture(frontSideDef.lower_texture);
			case BACK_TOP :
				return Engine.TEXTURES.getTexture(backSideDef.upper_texture);
			case BACK_MIDDLE :
				return Engine.TEXTURES.getTexture(backSideDef.middle_texture);
			case BACK_BOTTOM :
				return Engine.TEXTURES.getTexture(backSideDef.lower_texture);
		}
	}
	
	function get_solid():Bool 
	{
		if (backSideDef == null) return true;
		else return false;
	}
	
	function get_frontSideDef():SideDef 
	{
		return Engine.LEVELS.currentMap.sidedefs[frontSideDefID];
	}
	
	function get_backSideDef():SideDef 
	{
		return Engine.LEVELS.currentMap.sidedefs[backSideDefID];
	}
	
	function get_start():Vertex 
	{
		return Engine.LEVELS.currentMap.vertexes[startVertexID];
	}
	
	function get_end():Vertex 
	{
		return Engine.LEVELS.currentMap.vertexes[endVertexID];
	}
	
	public function toString() {
		return(
			['Start to End: {' + start.toString() +', ' + end.toString() + '}, ',
			'Line type: {' + special + '}, ',
			'Sector Tag: {' + sectorTag + '}, ',
			'Flags: {' + flags + '}, ',
			'Front Sidedef: {' + (frontSideDef != null ? 'Sidedef Tag: ' : 'No Front Sidedef') + '}, ',
			'Back Sidedef: {' + (backSideDef != null ? 'Sidedef Tag: ' : 'No Back Sidedef') + '}, ',
			'Solid: {' + solid + '}'
			].join("")
		);
	}
	
	override public function toDataBytes():Bytes 
	{
		var bytes = Bytes.alloc(BYTE_SIZE);
		
		bytes.setUInt16(0, startVertexID);
		bytes.setUInt16(2, endVertexID);
		bytes.setUInt16(4, flagsToBits());
		bytes.setUInt16(6, special);
		bytes.setUInt16(8, sectorTag);
		bytes.setUInt16(10, frontSideDefID);
		bytes.setUInt16(12, backSideDefID);
		
		return bytes;
	}
	
	function get_dy():Float 
	{
		return Math.abs(end.ypos - start.ypos);
	}
	
	function get_dx():Float 
	{
		return Math.abs(end.xpos - start.xpos);
	}
	
	override public function copy():LineDef
	{
		var line = LineDef.CONSTRUCTOR([
			startVertexID,
			endVertexID,
			flagsToBits(),
			special,
			sectorTag,
			frontSideDefID,
			backSideDefID
		]);
		return line;
	}
}