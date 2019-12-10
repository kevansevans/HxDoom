package hxdoom.wad.maplumps;

/**
 * ...
 * @author Kaelan
 */
class SubSector 
{
	public var segments:Array<Segment>;
	public function new(_segments:Array<Segment>, _count:Int, _id:Int) 
	{
		segments = new Array();
		for (_seg in _id...(_id + _count)) {
			segments.push(_segments[_seg]);
		}
	}
	
}