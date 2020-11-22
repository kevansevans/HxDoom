package hxdoom.lumps.map;

import haxe.io.Bytes;
import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class SideDef extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> SideDef = SideDef.new;
	
	public static inline var BYTE_SIZE:Int = 30;
	
	public var xoffset:Int;
	public var yoffset:Int;
	public var upper_texture:String;
	public var lower_texture:String;
	public var middle_texture:String;
	public var sectorID:Int;
	
	public var sector(get, null):Sector;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		if (override_new) return;
		
		xoffset = 			_args[0];
		yoffset = 			_args[1];
		upper_texture = 	_args[2];
		lower_texture = 	_args[3]; 
		middle_texture = 	_args[4];
		sectorID = 			_args[5];
	}
	
	function get_sector():Sector
	{
		return Engine.LEVELS.currentMap.sectors[sectorID];
	}
	
	public function toString():String {
		return([
			'Offsets: {x: ' + xoffset + ', y: ' + yoffset + '} ',
			'Upper Texture: {' + upper_texture + '}, ',
			'Middle Texture: {' + middle_texture + '}, ',
			'Lower Texture: {' + lower_texture + '}, '
		].join(""));
	}
	
	override public function toDataBytes():Bytes 
	{
		var str:String;
		var bytes = Bytes.alloc(BYTE_SIZE);
		bytes.setUInt16(0, xoffset);
		bytes.setUInt16(2, yoffset);
		
		str = upper_texture;
		while (str.length < 8) {
			str += String.fromCharCode(0);
		}
		for (char in 0...str.length) {
			bytes.set(4 + char, str.charCodeAt(char));
		}
		
		str = lower_texture;
		while (str.length < 8) {
			str += String.fromCharCode(0);
		}
		for (char in 0...str.length) {
			bytes.set(12 + char, str.charCodeAt(char));
		}
		
		str = middle_texture;
		while (str.length < 8) {
			str += String.fromCharCode(0);
		}
		for (char in 0...str.length) {
			bytes.set(20 + char, str.charCodeAt(char));
		}
		
		bytes.setUInt16(28, sectorID);
		
		return bytes;
	}
}