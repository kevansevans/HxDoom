package hxdoom.lumps.map;

import hxdoom.Engine;

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
	public var visible:Bool = false;
	public var frontSector(get, null):Sector;
	public var backSector(get, null):Sector;
	
	var randswatch = Std.int(254 * Math.random()) + 1;
			
	public var r_color:Float; 
	public var g_color:Float; 
	public var b_color:Float;
	
	public function new(_lineDefs:Array<LineDef>, _angle:Int, _lineID:Int, _direction:Int, _offset:Int) 
	{
		r_color = Engine.PLAYPAL.getColor(randswatch, 0, 0, true); 
		g_color = Engine.PLAYPAL.getColor(randswatch, 1, 0, true); 
		b_color = Engine.PLAYPAL.getColor(randswatch, 2, 0, true);
		
		angle = _angle;
		lineDef = _lineDefs[_lineID];
		direction = _direction;
		offset = _offset;
	}
	function get_start():Vertex 
	{
		return lineDef.start;
	}
	
	function get_sector():Sector 
	{
		return lineDef.frontSideDef.sector;
	}
	
	function get_frontSector():Sector 
	{
		return lineDef.frontSideDef.sector;
	}
	
	function get_backSector():Sector 
	{
		return lineDef.backSideDef.sector;
	}
	
	function get_end():Vertex 
	{
		return lineDef.end;
	}
}