package hxdoom.lumps.map;

/**
 * ...
 * @author Kaelan
 */
class SubSector 
{
	public var count:Int;
	public var firstSegID:Int;
	
	public var sector(get, null):Sector;
	public var segments(get, null):Array<Segment>;
	
	public function new(_count:Int, _firstSegID:Int) 
	{
		count = _count;
		firstSegID = _firstSegID;
		
	}
	
	function get_sector():Sector 
	{
		return Engine.ACTIVEMAP.segments[firstSegID].sector;
	}
	
	function get_segments():Array<Segment> 
	{
		var t_segments = new Array();
		for (_seg in firstSegID...(firstSegID + count)) {
			t_segments.push(Engine.ACTIVEMAP.segments[_seg]);
		}
		return(t_segments);
	}
	
	public function toString():String {
		return([
			'Num Segments: ' + segments.length
		].join(""));
	}
}