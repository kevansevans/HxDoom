package packages.wad.maplumps;

/**
 * ...
 * @author Kaelan
 */
class LineDef 
{
	public var start:Int;
	public var end:Int;
	public var flags:Int;
	public var lineType:Int;
	public var sectorTag:Int;
	public var frontSideDef:Int;
	public var backSideDef:Int;
	public function new(_start:Int, _end:Int, _flags:Int, _lineType:Int, _sectorTag:Int, _fronSideDef:Int, _backSideDef:Int) 
	{
		
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