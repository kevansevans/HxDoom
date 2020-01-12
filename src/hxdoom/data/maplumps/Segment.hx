package hxdoom.data.maplumps;

/**
 * ...
 * @author Kaelan
 */
class Segment 
{
	public var start(get, null):Vertex;
	public var end(get, null):Vertex;
	public var angle:Int;
	public var lineDef:LineDef;
	public var direction:Int;
	public var offset:Int;
	public var hasBeenSeen:Bool = false;
	public var GLOffset:Int;
	
	public function new(_lineDefs:Array<LineDef>, _angle:Int, _lineID:Int, _direction:Int, _offset:Int) 
	{
		angle = _angle;
		lineDef = _lineDefs[_lineID];
		direction = _direction;
		offset = _offset;
	}
	function get_start():Vertex 
	{
		return lineDef.start;
	}
	function get_end():Vertex 
	{
		return lineDef.end;
	}
}