package hxdoom.lumps.map;

import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class SubSector extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> SubSector = SubSector.new;
	
	public var count:Int;
	public var firstSegID:Int;
	
	public var sector(get, null):Sector;
	public var segments(get, null):Array<Segment>;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		count = 		_args[0];
		firstSegID = 	_args[1];
	}
	
	function get_sector():Sector 
	{
		return Engine.LEVELS.currentMap.segments[firstSegID].sector;
	}
	
	function get_segments():Array<Segment> 
	{
		var t_segments = new Array();
		for (_seg in firstSegID...(firstSegID + count)) {
			t_segments.push(Engine.LEVELS.currentMap.segments[_seg]);
		}
		return(t_segments);
	}
	
	public function toString():String {
		return([
			'Num Segments: ' + segments.length
		].join(""));
	}
}