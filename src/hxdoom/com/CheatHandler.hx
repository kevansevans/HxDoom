package hxdoom.com;
import haxe.ds.Vector;

#if macro
import haxe.Json;
import haxe.macro.Context;
import haxe.Resource;
import sys.FileSystem;
import sys.io.File;
#end

/**
 * ...
 * @author Kaelan
 */
class CheatHandler 
{
	var keylogger:Array<String>;
	
	public function new() 
	{
		keylogger = new Array();
		keylogger.resize(20);
	}
	
	public function logKeyStroke(_key:String) {
		keylogger.unshift(_key.toLowerCase());
		keylogger.resize(20);
		checkCheat();
	}
	
	/*
	 * This is a macro function that builds the switch statement for checking if
	 * the user has typed in a valid cheat code. This code DOES NOT hot load cheats
	 * into the engine, it only pre-builds them to reduce the work necesary checking
	 * for them. The JSON file cheats.txt is where a developer can add/remove cheat detection,
	 * and alter the behavior of said cheats.
	 */
	
	public static macro function checkCheat() {
		var switch_block:Array<String> = new Array();
		
		//DO NOT TOUCH ANY OF THIS BELOW
		switch_block = 	['{',
			'var log = keylogger.copy();',
			'log.reverse();',
			'switch (log) {',
				'default :',
					'doNothing();',
			'}',
		'}'];
		//DO NOT TOUCH ANY OF THIS ABOVE
		
		var file = File.getBytes("./assets/json/cheats.txt");
		var codesheet:Dynamic = Json.parse(file.getString(0, file.length));
		var currentgame:Dynamic;
		var currentcheat:Dynamic;
		
		for (game in Reflect.fields(codesheet)) {
			
			currentgame = Reflect.getProperty(codesheet, game);
			
			for (cheatcode in Reflect.fields(currentgame)) {
				
				currentcheat = Reflect.getProperty(currentgame, cheatcode);
				
				var caseheader = 'case [';
				var length:Int = 20 - Std.int(cheatcode.length);
				for (a in 0...length) {
					caseheader += '_, ';
				}
				for (a in 0...cheatcode.length) {
					caseheader += '"' + cheatcode.substr(a, 1) + '", ';
				}
				caseheader = caseheader.substring(0, caseheader.length - 2);
				caseheader += '] :';
				
				var actionblock:String = '';
				
				var scripts:Array<Dynamic> = cast(currentcheat, Array<Dynamic>);
				
				for (actions in scripts) {
					switch (cast(actions, String)) {
						case "logplayerposition" :
							actionblock += 'logPlayerPosition();';
						default :
							var act = "" + actions;
							actionblock += 'cheatNotHandled("poop");';
					}
				}
				
				switch_block.insert(4, caseheader);
				switch_block.insert(5, actionblock);
			}
		}
		
		var code = switch_block.join("");
		
		return Context.parse(code, Context.currentPos());
	}
	//cheat functions
	public function doNothing(){};
	public function cheatNotHandled(_cheat:String) {
		trace("Cheat not set yet: " + _cheat);
	}
	public function logPlayerPosition() {
		Engine.log("x: " + Engine.ACTIVEMAP.actors_players[0].xpos + " y: " + Engine.ACTIVEMAP.actors_players[0].ypos);
	}
}