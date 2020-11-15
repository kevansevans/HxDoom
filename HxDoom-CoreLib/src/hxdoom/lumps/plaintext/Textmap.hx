package hxdoom.lumps.plaintext;

import hxdoom.component.LevelMap;
import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */

class Textmap extends LumpBase
{
	public static var CONSTRUCTOR:Array<Any> -> Textmap = Textmap.new;
	
	public static var GLOBAL:Map<String, String> = new Map();
	
	var data:Array<Int>;
	var blocks:Array<BlockData>;
	var lines:Array<StringBuf>;
	
	var map:LevelMap;
	
	var tempString:StringBuf = new StringBuf();
	
	var doubleSlashComment:Bool = false;
	var slashAsteriskComment:Bool = false;
	
	var inBlock:Bool = false;
	var expectingBlock:Bool = false;
	var nameSpaceFound:Bool = false;
	
	var regKeyword:EReg = new EReg('[^{}();"' + '\'' + '\n\t ]+', "i");
	var regFloat:EReg = new EReg("[+-]?[0-9]+'.'[0-9]*([eE][+-]?[0-9]+)?", "i");
	
	var lineNum:Int = 0;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		data = _args[0];
		
		lines = new Array();
		blocks = new Array();
		
		//data sanitization here.
		//Remove whitespaces and break up "chunks" into lines.
		
		for (index in 0...data.length) {
			
			switch(data[index]) {
				
				case "\n".code :
					
					if (doubleSlashComment) doubleSlashComment = false;
					if (slashAsteriskComment) continue;
					
					if (tempString.length != 0) {
						
						if (checkLine(tempString.toString())) {
							
							tempString = new StringBuf();
							lines.push(tempString);
							
							++lineNum;
						} else {
							//Some error throw here
						}
					}
					continue;
					
				case "{".code | "}".code | ";".code :
					
					if (doubleSlashComment) continue;
					if (slashAsteriskComment) continue;
					
					if (data[index] == "{".code && expectingBlock) {
						expectingBlock = false;
						inBlock = true;
					} else {
						//error! Opening brace expected
					}
					
					if (data[index] == "}".code && inBlock) {
						inBlock = false;
					}
					
					tempString.addChar(data[index]);
					
					if (checkLine(tempString.toString())) {
						lines.push(tempString);
						tempString = new StringBuf();
					} else {
						//some error throw here
					}
					
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
					
				case " ".code | "\t".code : //eliminate whitespace
					continue;
				default :
					
					if (doubleSlashComment) continue;
					if (slashAsteriskComment) continue;
					if (expectingBlock) {
						//error! We're expecting a '{'
					}
					
					tempString.addChar(data[index]);
					continue;
			}
		}
		
		Engine.LEVELS.currentMap = map;
		
	}
	
	function checkLine(_string:String):Bool
	{
		if (!inBlock) {
			//namespace or keyword check
			var split:Array<String> = tempString.toString().split("=");
			if (split.length == 2) { //Global keyword
				if (regKeyword.match(split[0])) {
					if (split[1].lastIndexOf(";") == -1) { //does it terminate?
						return false;
					}
					if (split[1].length <= 1) {
						//Error! I'm undefined!
					}
					Textmap.GLOBAL[split[0]] = split[1];
					return true;
				} else {
					//Error! Wtf did you type?
					return false;
				}
			} else if (split.length == 1) { //Keyword
				if (regKeyword.match(split[0])) {
					expectingBlock = true; // we don't know if we're in a block or not just yet
				}
			}
		} else {
			//we're in a block, we HAVE to expect split to return an array of 2
		}
		
		return false; //Make sure this NEVER gets reached, only here so Haxe doesn't throw a fit
	}
}

typedef BlockData = {
	var lumpType:String;
	var lines:Array<String>;
}