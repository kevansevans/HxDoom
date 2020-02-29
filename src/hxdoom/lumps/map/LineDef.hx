package hxdoom.lumps.map;

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
	public var solid(get, null):Bool;
	
	public var color_r(get, null):Float;
	public var color_g(get, null):Float;
	public var color_b(get, null):Float;
	
	
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
	
	function get_color_r():Float 
	{
		return color_r;
	}
	
	function get_color_g():Float 
	{
		return color_g;
	}
	
	function get_solid():Bool 
	{
		if (backSideDef == null) return true;
		else return false;
	}
	
	function get_color_b():Float 
	{
		return color_b;
	}
}