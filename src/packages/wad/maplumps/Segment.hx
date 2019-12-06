package packages.wad.maplumps;

/**
 * ...
 * @author Kaelan
 */
class Segment 
{
	public var start:Vertex;
	public var end:Vertex;
	public var angle:Int;
	public var lineDefID:Int;
	public var direction:Int;
	public var offset:Int;
	public function new(_vertexes:Array<Vertex>, _startID:Int, _endID:Int, _angle:Int, _lineID:Int, _direction:Int, _offset:Int) 
	{
		start = _vertexes[_startID];
		end = _vertexes[_endID];
		angle = _angle;
		lineDefID = _lineID;
		direction = _direction;
		offset = _offset;
	}
	
}