package hxdoom.lumps.map;

/**
 * ...
 * @author Kaelan
 */
class LineDef 
{
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
	
	public function new(_start:Int, _end:Int, _flags:Int, _lineType:Int, _sectorTag:Int, _frontSideDef:Int, _backSideDef:Int) 
	{
		startVertexID = _start;
		endVertexID = _end;
		flags = _flags;
		lineType = _lineType;
		sectorTag = _sectorTag;
		frontSideDefID = _frontSideDef;
		backSideDefID = _backSideDef;
	}
	
	function get_solid():Bool 
	{
		if (backSideDef == null) return true;
		else return false;
	}
	
	function get_frontSideDef():SideDef 
	{
		return Engine.ACTIVEMAP.sidedefs[frontSideDefID];
	}
	
	function get_backSideDef():SideDef 
	{
		return Engine.ACTIVEMAP.sidedefs[backSideDefID];
	}
	
	function get_start():Vertex 
	{
		return Engine.ACTIVEMAP.vertexes[startVertexID];
	}
	
	function get_end():Vertex 
	{
		return Engine.ACTIVEMAP.vertexes[endVertexID];
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