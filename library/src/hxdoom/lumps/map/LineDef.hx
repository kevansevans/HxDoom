package hxdoom.lumps.map;

import hxdoom.Engine;

import hxdoom.lumps.graphic.Texture;

import hxdoom.enums.eng.SideType;

/**
 * ...
 * @author Kaelan
 */
class LineDef 
{
	public static var CONSTRUCTOR:(Array<Any>) -> LineDef = LineDef.new;
	
	public var flags:Int;
	public var lineType:Int;
	public var sectorTag:Int;
	var frontSideDefID:Int;
	var backSideDefID:Int;
	var startVertexID:Int;
	var endVertexID:Int;
	public var solid(get, null):Bool;
	
	public var frontSideDef(get, null):SideDef;
	public var backSideDef(get, null):SideDef;
	public var start(get, null):Vertex;
	public var end(get, null):Vertex;
	
	public function new(_args:Array<Any>) 
	{
		startVertexID = 	_args[0];
		endVertexID = 		_args[1];
		flags = 			_args[2];
		lineType = 			_args[3];
		sectorTag = 		_args[4];
		frontSideDefID = 	_args[5];
		backSideDefID = 	_args[6];
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
			'Line type: {' + lineType + '}, ',
			'Sector Tag: {' + sectorTag + '}, ',
			'Flags: {' + flags + '}, ',
			'Front Sidedef: {' + (frontSideDef != null ? 'Sidedef Tag: ' : 'No Front Sidedef') + '}, ',
			'Back Sidedef: {' + (backSideDef != null ? 'Sidedef Tag: ' : 'No Back Sidedef') + '}, ',
			'Solid: {' + solid + '}'
			].join("")
		);
	}
}