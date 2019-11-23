package packages.wad.maplumps;

/**
 * ...
 * @author Kaelan
 */
class SubSector 
{
	public var segmentCount:Int;
	public var firstSegmentID:Int;
	public function new(_count:Int, _id:Int) 
	{
		segmentCount = _count;
		firstSegmentID = _id;
	}
	
}