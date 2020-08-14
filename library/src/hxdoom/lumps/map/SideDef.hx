package hxdoom.lumps.map;

/**
 * ...
 * @author Kaelan
 */
class SideDef 
{
	public static var CONSTRUCTOR:(Array<Any>) -> SideDef = SideDef.new;
	
	public var xoffset:Int;
	public var yoffset:Int;
	public var upper_texture:String;
	public var lower_texture:String;
	public var middle_texture:String;
	public var sectorID:Int;
	
	public var sector(get, null):Sector;
	
	public function new(_args:Array<Any>) 
	{
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
}