package hxdoom.lumps.map;

import haxe.io.Bytes;
import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class SubSector extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> SubSector = SubSector.new;
	
	public static inline var BYTE_SIZE:Int = 4;
	
	public var count:Int;
	public var firstSegID:Int;
	
	public var sector(get, null):Sector;
	public var segments(get, null):Array<Segment>;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		if (override_new) return;
		
		count = 		_args[0];
		firstSegID = 	_args[1];
	}
	
	override public function copy():SubSector
	{
		var subsector = SubSector.CONSTRUCTOR([
			count,
			firstSegID
		]);
		return subsector;
	}
	
	public function get_sector():Sector 
	{
		return Engine.LEVELS.currentMap.segments[firstSegID].sector;
	}
	
	public function get_segments():Array<Segment> 
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
	
	override public function toDataBytes():Bytes 
	{
		var bytes = Bytes.alloc(BYTE_SIZE);
		bytes.setUInt16(0, count);
		bytes.setUInt16(2, firstSegID);
		return bytes;
	}
}