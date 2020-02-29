package hxdoom.lumps.maplumps;

/**
 * ...
 * @author Kaelan
 */
class Sector 
{
	public var floorHeight:Int;
	public var ceilingHeight:Int;
	public var floorTexture:String;
	public var ceilingTexture:String;
	public var lightLevel:Int;
	public var special:Int;
	public var tag:Int;
	public function new(_floorHeight:Int, _ceilingHeight:Int, _floorTexture:String, _ceilingTexture:String, _lightLevel:Int, _special:Int, _tag:Int) 
	{
		floorHeight = _floorHeight;
		ceilingHeight = _ceilingHeight;
		floorTexture = _floorTexture;
		ceilingTexture = _ceilingTexture;
		lightLevel = _lightLevel;
		special = _special;
		tag = _tag;
	}
	
}