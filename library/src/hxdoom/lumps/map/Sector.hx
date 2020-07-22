package hxdoom.lumps.map;

/**
 * ...
 * @author Kaelan
 */
class Sector 
{
	public static var CONSTRUCTOR:(Array<Any>) -> Sector = Sector.new;
	
	public var floorHeight:Int;
	public var ceilingHeight:Int;
	public var floorTexture:String;
	public var ceilingTexture:String;
	public var lightLevel:Int;
	public var special:Int;
	public var tag:Int;
	public function new(_args:Array<Any>) 
	{
		floorHeight = 		_args[0];
		ceilingHeight = 	_args[1];
		floorTexture = 		_args[2];
		ceilingTexture = 	_args[3];
		lightLevel = 		_args[4];
		special = 			_args[5];
		tag = 				_args[6];
	}
	
	public function toString():String
	{
		return([
			'Floor: {Height: ' + floorHeight + ', Texture: ' + floorTexture + '}, ',
			'Ceiling: {Height: ' + ceilingHeight + ', Texture: ' + ceilingTexture + '}, ',
			'Light: {' + lightLevel + '}, ',
			'Special: {' + special + '}, ',
			'Tag: {' + tag + '}, '
		].join(""));
	}
}