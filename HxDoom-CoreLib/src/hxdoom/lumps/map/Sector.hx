package hxdoom.lumps.map;
import haxe.io.Bytes;
import hxdoom.component.Actor;
import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class Sector extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> Sector = Sector.new;
	
	public static inline var BYTE_SIZE:Int = 26;
	
	public var floorHeight:Float;
	public var ceilingHeight:Float;
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
	
	public static function getSortedVerticies(_sector:Sector):Array<Vertex> {
		
		var sector = _sector;
		
		var worklines:Array<LineDef> = _sector.lines.copy();
		var rings:Array<Array<LineDef>> = new Array();
		var currentLine = worklines[0];
		var startLine = worklines[0];
		var sortedLines:Array<LineDef> = new Array();
		var dumpLines:Array<LineDef> = new Array();
		
		sortedLines.push(startLine);
		worklines.remove(startLine);
		
		var parsing:Bool = true;
		
		if (_sector.lines.length == 3) 
		{
			
			for (line in _sector.lines) sortedLines.push(line);
			
		} else {
			
			var ignoreVert:Vertex = null;
			
			while (parsing) {
				
				var vert_a:Vertex = currentLine.frontSideDef.sectorID == Engine.LEVELS.currentMap.sectors.indexOf(_sector) ? currentLine.start : currentLine.end;
				
				var connected:Bool = false;
				
				dumpLines = new Array();
				
				for (line in worklines) {
					
					dumpLines.push(line);
					
					var vert_b:Vertex = line.frontSideDef.sectorID == Engine.LEVELS.currentMap.sectors.indexOf(_sector) ? line.end : line.start;
					
					if (vert_b == ignoreVert) vert_b = vert_b == line.end ? line.start : line.end;
					
					if (vert_a == vert_b) {
						
						connected = true;
						
						sortedLines.push(line);
						worklines.remove(line);
						currentLine = line;
						
						ignoreVert = vert_b;
						
						if (worklines.length == 0) parsing = false;
						
						//get opposite verts
						var vert_c:Vertex = vert_b == line.start ? line.end : line.start;
						var vert_d:Vertex = vert_a == startLine.start ? startLine.start : startLine.end;
						
						if (vert_c == vert_d) {
							if (worklines.length == 0) {
								parsing = false;
							}
							else {
								
								rings.push(sortedLines.copy());
								
								currentLine = worklines[0];
								startLine = worklines[0];
								sortedLines = new Array();
								
								sortedLines.push(startLine);
								worklines.remove(startLine);
								
							}
						}
						
					}
					
				}
				
				//dead end check
				if (!connected) {
					for (line in dumpLines) worklines.remove(line);
				}
				
				if (worklines.length == 0) {
					parsing = false;
				}
			}
		}
		
		
		rings.reverse();
		
		sortedLines.push(sortedLines[0]);
		
		while (rings.length > 0) {
			
			var indexLine:LineDef = null;
			var shortest:Float = Math.POSITIVE_INFINITY;
			
			for (line_a in sortedLines) for (line_b in rings[0]) {
				
				var dist_a = Vertex.distance(line_a.start, line_b.start);
				var dist_b = Vertex.distance(line_a.start, line_b.end);
				var dist_c = Vertex.distance(line_a.end, line_b.end);
				
				if (dist_a < shortest || dist_b < shortest || dist_c < shortest) {
					indexLine = line_a;
				} else {
					continue;
				}
			}
			
			if (indexLine == null) trace("Problem!");
			else {
				for (line in rings[0]) {
					sortedLines.insert(sortedLines.indexOf(indexLine), line);
				}
				sortedLines.insert(sortedLines.indexOf(indexLine), rings[0][0]);
				rings.shift();
			}
			
		}
		
		var verts:Array<Vertex> = new Array();
		
		for (line in sortedLines) {
			if (line.frontSideDef.sectorID == Engine.LEVELS.currentMap.sectors.indexOf(sector)) {
				verts.push(line.start);
			} else {
				verts.push(line.end);
			}
		}
		
		return verts;
	}
}