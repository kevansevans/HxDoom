package hxdoom.data.maplumps;

/**
 * ...
 * @author Kaelan
 */
class SubSector 
{
	public var segments:Array<Segment>;
	public var sector:Sector;
	public function new(_segments:Array<Segment>, _count:Int, _id:Int) 
	{
		segments = new Array();
		for (_seg in _id...(_id + _count)) {
			segments.push(_segments[_seg]);
		}
		sector = segments[0].direction == 0 ? segments[0].frontSector : segments[0].backSector;
	}
	
}