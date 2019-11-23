package packages.wad.maplumps;

/**
 * ...
 * @author Kaelan
 */
class Segment 
{
	public var startVertexID:Int;
	public var endVertexID:Int;
	public var angle:Int;
	public var lineDefID:Int;
	public var direction:Int;
	public var offset:Int;
	public function new(_startID:Int, _endID:Int, _angle:Int, _lineID:Int, _direction:Int, _offset:Int) 
	{
		startVertexID = _startID;
		endVertexID = _endID;
		angle = _angle;
		lineDefID = _lineID;
		direction = _direction;
		offset = _offset;
	}
	
}