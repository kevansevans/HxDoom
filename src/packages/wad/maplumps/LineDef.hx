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
	public var frontSideDef:SideDef;
	public var backSideDef:SideDef;
	public function new(_vertexes:Array<Vertex>, _sidedefs:Array<SideDef>, _start:Int, _end:Int, _flags:Int, _lineType:Int, _sectorTag:Int, _frontSideDef:Int, _backSideDef:Int) 
	{
		start = _vertexes[_start];
		end = _vertexes[_end];
		flags = _flags;
		lineType = _lineType;
		sectorTag = _sectorTag;
		frontSideDef = _sidedefs[_frontSideDef];
		backSideDef = _sidedefs[_backSideDef];
	}
	
}