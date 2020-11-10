package hxdoom.lumps.plaintext;

import hxdoom.component.LevelMap;
import hxdoom.lumps.LumpBase;
import hxdoom.lumps.map.LineDef;
import hxdoom.lumps.map.Sector;
import hxdoom.lumps.map.SideDef;
import hxdoom.lumps.map.Thing;
import hxdoom.lumps.map.Vertex;
import hxdoom.utils.geom.Angle;

/**
 * ...
 * @author Kaelan
 */
class Textmap extends LumpBase
{
	public static var CONSTRUCTOR:Array<Any> -> Textmap = Textmap.new;
	
	var data:Array<Int>;
	var blocks:Array<BlockData>;
	var lines:Array<StringBuf>;
	
	var map:LevelMap;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		data = _args[0];
		
		lines = new Array();
		blocks = new Array();
		
		//data sanitization here.
		//Remove whitespaces and break up "chunks" into lines.
		
		var tempString:StringBuf = new StringBuf();
		
		var doubleSlashComment:Bool = false;
		var slashAsteriskComment:Bool = false;
		
		for (index in 0...data.length) {
			
			switch(data[index]) {
				
				case "\n".code :
					
					if (doubleSlashComment) doubleSlashComment = false;
					if (slashAsteriskComment) continue;
					
					if (tempString.length != 0) lines.push(tempString);
					tempString = new StringBuf();
					continue;
					
				case "{".code | "}".code | ";".code :
					
					if (doubleSlashComment) continue;
					if (slashAsteriskComment) continue;
					
					tempString.addChar(data[index]);
					lines.push(tempString);
					tempString = new StringBuf();
					
					continue;
					
				case "/".code :
					
					if (doubleSlashComment) continue;
					
					if (String.fromCharCode(data[index + 1]) == '/') {
						doubleSlashComment = true;
						continue;
					}
					
					if (String.fromCharCode(data[index + 1]) == '*') {
						slashAsteriskComment = true;
						continue;
					}
					
				case "*".code :
					
					if (String.fromCharCode(data[index + 1]) == '/') {
						slashAsteriskComment = false;
						continue;
					}
					
				case " ".code : //eliminate whitespace
					continue;
				default :
					
					if (doubleSlashComment) continue;
					if (slashAsteriskComment) continue;
					
					tempString.addChar(data[index]);
					continue;
			}
		}
		
		var inBlock:Bool = false;
		var tempLines:Array<String> = new Array();
		var itemType:String = "";
		var index:Int = 0;
		for (line in lines) {
			var str:String = line.toString();
			if (!inBlock) {
				if (str.charAt(0) == '{') {
					
					inBlock = true;
					
					tempLines = new Array();
					itemType = lines[index - 1].toString();
					continue;
				}
			} else {
				if (str.charAt(0) == '}') {
					inBlock = false;
					var block:BlockData = {
						lumpType : itemType,
						lines : tempLines
					}
					blocks.push(block);
				} else {
					var newLine:String = line.toString();
					newLine = newLine.substr(0, newLine.indexOf(";"));
					tempLines.push(newLine);
				}
			}
			++index;
		}
		
		map = new LevelMap();
		
		//interpret code here
		
		Engine.LEVELS.currentMap = map;
		
	}
	
}

typedef BlockData = {
	var lumpType:String;
	var lines:Array<String>;
}