package hxdoom.lumps.map;

import hxdoom.Engine;

/**
 * ...
 * @author Kaelan
 */
class Segment 
{
	public var angle:Int;
	public var lineID:Int;
	public var side:Int;
	public var offset:Int;
	
	public var start(get, null):Vertex;
	public var end(get, null):Vertex;
	public var sector(get, null):Sector;
	public var lineDef(get, null):LineDef;
	
	public function new(_angle:Int, _lineID:Int, _side:Int, _offset:Int) 
	{
		angle = _angle;
		lineID = _lineID;
		side = _side;
		offset = _offset;
	}
	
	function get_start():Vertex 
	{
		return Engine.ACTIVEMAP.linedefs[lineID].start;
	}
	
	function get_end():Vertex 
	{
		return Engine.ACTIVEMAP.linedefs[lineID].end;
	}
	
	function get_sector():Sector 
	{
		if (side == 0) {
			return lineDef.frontSideDef.sector;
		} else {
			return lineDef.backSideDef.sector;
		}
	}
	
	function get_lineDef():LineDef 
	{
		return Engine.ACTIVEMAP.linedefs[lineID];
	}
	
	public function toString():String {
		return([
			'Angle: {' + angle + '}, ',
			'Direction: {' + (side == 0 ? '0: Front' : '1: back') + '}, ',
			'Offset: {' + offset + '}, ',
			'Sector: {' + sector + '}, '
		].join(""));
	}
}