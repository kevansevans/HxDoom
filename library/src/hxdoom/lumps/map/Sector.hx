package hxdoom.lumps.map;
import haxe.io.Bytes;
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
	
	override public function toDataBytes():Bytes 
	{
		var str:String;
		var bytes = Bytes.alloc(BYTE_SIZE);
		
		bytes.setUInt16(0, floorHeight);
		bytes.setUInt16(2, ceilingHeight);
		
		str = floorTexture;
		while (str.length < 8) {
			str += String.fromCharCode(0);
		}
		for (char in 0...str.length) {
			bytes.set(4 + char, str.charCodeAt(char));
		}
		
		str = ceilingTexture;
		while (str.length < 8) {
			str += String.fromCharCode(0);
		}
		for (char in 0...str.length) {
			bytes.set(12 + char, str.charCodeAt(char));
		}
		
		bytes.setUInt16(20, lightLevel);
		bytes.setUInt16(22, special);
		bytes.setUInt16(24, tag);
		
		return bytes;
	}
}