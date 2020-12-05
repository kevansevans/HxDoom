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
		
		if (override_new) return;
		
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
		
		bytes.setUInt16(0, Std.int(floorHeight));
		bytes.setUInt16(2, Std.int(ceilingHeight));
		
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
			sortedLines = new Array();
			
			for (line in _sector.lines) sortedLines.push(line);
			
			return toSortedVertices(sortedLines, sector);
			
		} else {
			
			var ignoreVert:Vertex = null;
			
			while (parsing) {
				
				var vert_a:Vertex = currentLine.frontSideDef.sectorID == sector.lumpID ? currentLine.start : currentLine.end;
				
				var connected:Bool = false;
				
				dumpLines = new Array();
				
				for (line in worklines) {
					
					dumpLines.push(line);
					
					var vert_b:Vertex = line.frontSideDef.sectorID == sector.lumpID ? line.end : line.start;
					
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
		
		if (rings.length > 0) {
			
			var vertRings:Array<Array<Vertex>> = new Array();
			
			rings.push(sortedLines);
			
			for (ring in rings) {
				var sortedVertRing:Array<Vertex> = toSortedVertices(ring, sector);
				vertRings.push(sortedVertRing);
			}
			
			var returnVerts:Array<Vertex> = new Array();
			
			while (vertRings.length > 0) {
				
				var sharesIntersection:Bool = false;
				
				if (returnVerts.length == 0) {
					for (vert in vertRings[0]) {
						returnVerts.push(vert);
					}
					vertRings.remove(vertRings[0]);
				} else {
					var shortest:Float = Math.POSITIVE_INFINITY;
					var indexVertA:Vertex = null;
					var indexVertB:Vertex = null;
					
					for (vertA in returnVerts) for (vertB in vertRings[0]) {
						
						if (Vertex.distance(vertA, vertB) == 0) {
							sharesIntersection = true;
							indexVertA = vertA;
							indexVertB = vertB;
							break;
						} else if (Vertex.distance(vertB, vertA) < shortest) {
							shortest = Vertex.distance(vertA, vertB);
							indexVertA = vertA;
							indexVertB = vertB;
						}
						
					}
					
					while (returnVerts.indexOf(indexVertA) != 0) returnVerts.push(returnVerts.shift());
					while (vertRings[0].indexOf(indexVertB) != 0) vertRings[0].push(vertRings[0].shift());
					
					if (!sharesIntersection) {
						vertRings[0].push(indexVertB.copy());
						returnVerts.push(indexVertA.copy());
					}
					
					for (vert in vertRings[0]) {
						returnVerts.push(vert);
					}
					
					vertRings.remove(vertRings[0]);
				}
				
			}
			
			var lowestVert:Vertex = null;
			var lowset = Math.POSITIVE_INFINITY;
			
			for (vert in returnVerts) {
				if (vert.lumpID < lowset) {
					lowestVert = vert;
					lowset = vert.lumpID;
				}
			}
			
			while (returnVerts.indexOf(lowestVert) != 0) returnVerts.push(returnVerts.shift());
			
			return returnVerts;
			
		} else {
			return toSortedVertices(sortedLines, sector);
		}
		
		
	}
	
	static function toSortedVertices(_lines:Array<LineDef>, _sector:Sector):Array<Vertex>
	{
		var verts:Array<Vertex> = new Array();
		
		for (line in _lines) {
			if (line.frontSideDef.sectorID == _sector.lumpID) {
				verts.push(line.start);
			} else {
				verts.push(line.end);
			}
		}
		
		return verts;
	}
}