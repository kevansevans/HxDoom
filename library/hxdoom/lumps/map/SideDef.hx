package hxdoom.lumps.map;

/**
 * ...
 * @author Kaelan
 */
class SideDef 
{
	public var xoffset:Int;
	public var yoffset:Int;
	public var upper_texture:String;
	public var lower_texture:String;
	public var middle_texture:String;
	public var sectorID:Int;
	
	public var sector(get, null):Sector;
	
	public function new(_xoff:Int, _yoff:Int, _upper:String, _lower:String, _middle:String, _sectorID:Int) 
	{
		xoffset = _xoff;
		yoffset = _yoff;
		upper_texture = _upper;
		lower_texture = _lower; 
		middle_texture = _middle;
		sectorID = _sectorID;
	}
	
	function get_sector():Sector
	{
		return Engine.ACTIVEMAP.sectors[sectorID];
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