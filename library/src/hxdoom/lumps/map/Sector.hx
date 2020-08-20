package hxdoom.lumps.map;
import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class Sector extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> Sector = Sector.new;
	
	public static inline var BYTE_SIZE:Int = 26;
	
	public var floorHeight:Int;
	public var ceilingHeight:Int;
	public var floorTexture:String;
	public var ceilingTexture:String;
	public var lightLevel:Int;
	public var special:Int;
	public var tag:Int;
	public function new(_args:Array<Any>) 
	{
		super();
		
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