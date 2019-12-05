package packages.wad.maplumps;

/**
 * ...
 * @author Kaelan
 */
class LineDef 
{
	public var start:Vertex;
	public var end:Vertex;
	public var flags:Int;
	public var lineType:Int;
	public var sectorTag:Int;
	public var frontSideDef:Int;
	public var backSideDef:Int;
	public function new(_vertexes:Array<Vertex>, _start:Int, _end:Int, _flags:Int, _lineType:Int, _sectorTag:Int, _fronSideDef:Int, _backSideDef:Int) 
	{
		start = _vertexes[_start];
		end = _vertexes[_end];
		flags = _flags;
		lineType = _lineType;
		sectorTag = _sectorTag;
		frontSideDef = _fronSideDef;
		backSideDef = _backSideDef;
	}
	
}
/*
typedef LineDef = {
	var start:Int;
	var end:Int;
	var flags:Int;
	var linetype:Int;
	var sectortag:Int;
	var frontsidedef:Int;
	var backsidedef:Int;
}
*/