package hxdoom.lumps.map;
import haxe.io.Bytes;
import hxdoom.component.Actor;
import hxdoom.enums.eng.PlaneType;
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
	
	public var soundtraversed:Int = 0;
	public var soundtarget:Actor;
	
	//todo: Get this shiz working
	public var lines:Array<LineDef>;
	
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
	
	/**
	 * Helper function to calculate a GL compatible triangle model of a sector
	 * @param	_sectorID
	 * @return
	 */
	public static function getSectorGLTris(_sector:Sector, _mode:PlaneType):Array<Float> {
		var tris:Array<Float> = new Array();
		
		var sector:Sector = _sector;
		var mapSegs:Array<Segment> = Engine.LEVELS.currentMap.segments.copy();
		var sectorSegs:Array<Segment> = new Array();
		
		for (seg in mapSegs) {
			if (seg.sector == sector) sectorSegs.push(seg);
		}
		
		var vertexArray:Array<Vertex> = new Array();
		var anchor_seg:Segment = mapSegs.shift();
		vertexArray.push(anchor_seg.start);
		while (true) {
			
			var foundConnection:Bool = false;
			
			for (lookup_seg in mapSegs) {
				if (anchor_seg.end.xpos == lookup_seg.start.xpos && anchor_seg.end.ypos == lookup_seg.start.ypos) {
					foundConnection = true;
					vertexArray.push(lookup_seg.start);
					vertexArray.push(lookup_seg.end);
					anchor_seg = lookup_seg;
					mapSegs.remove(lookup_seg);
				}
			}
			
			if (!foundConnection) anchor_seg = mapSegs.shift();
			
			if (mapSegs.length == 0) {
				break;
			}
			
		}
		
		
		//ear clip stuff
		
		return tris;
	}
}