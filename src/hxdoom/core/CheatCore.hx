package hxdoom.core;
import haxe.ds.Vector;

#if macro
import haxe.Json;
import haxe.macro.Context;
import haxe.Resource;
import sys.FileSystem;
import sys.io.File;
#end

import hxdoom.common.GameActions;

/**
 * ...
 * @author Kaelan
 */
class CheatCore 
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
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//DO NOT TOUCH ANY OF THIS BELOW
	////////////////////////////////////////////////////////////////////////////////////////////////////
	/**/
	/**/	var switch_block:Array<String> = new Array();												
	/**/	
	/**/	switch_block = 	['{',
	/**/		'var log = keylogger.copy();',
	/**/		'log.reverse();',
	/**/		'switch (log) {',
	/**/			'default :',
	/**/				'doNothing();',
	/**/		'}',
	/**/	'}'];
	/**
	 * 		Okay, touch it if you really have to after THIS point. The below code is set up
	 * 		to parse through a JSON file where the field names are completely unknown, but assumed
	 * 		to hold a very specific structure and is correctly formatted to the JSON standard.
	 * 		the structure is as follows:
	 * 
	 * 		associated game -> key combo -> conditions to apply
	 * 
	 *		{
	 *			"doom": {
	 *				"iddqd": [
	 *					"pseudoinvul"
	 *				]
	 * 			}
	 * 		}
	 * 
	 * 		the parser below will turn the above JSON into the following two strings:
	 * 		
	 * 			case [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, "i", "d", "d", "q", "d"] :
	 * 
	 *		and... 
	 * 		
	 * 			GameActions.cheat_degreeless();
	 * 
	 * 		These are in the correct syntax that haxe expects. It then inserts those two strings
	 * 		into the array above. The array above is very delicate, do not touch it. Once the array is
	 * 		finished, the Haxe macro compiler will then turn it into valid Haxe code and inline it into where
	 * 		checkCheat(); happens above. This code is precompiled before the main program is compiled,
	 * 		this class WILL NOT hotload cheats into the engine, this is to provide an easy API for
	 * 		anyone on the dev side of things to easily modify cheat code behavior.
	 */ 
	/**/	var codesheet:Dynamic = Json.parse(json_cheat);
	/**/	var currentgame:Dynamic;
	/**/	var currentcheat:Dynamic;
	/**/	
	/**/	for (game in Reflect.fields(codesheet)) {
	/**/		
	/**/		currentgame = Reflect.getProperty(codesheet, game);
	/**/		
	/**/		for (cheatcode in Reflect.fields(currentgame)) {
	/**/			
	/**/			currentcheat = Reflect.getProperty(currentgame, cheatcode);
	/**/			
	/**/			var caseheader = 'case [';
	/**/			var length:Int = 20 - Std.int(cheatcode.length); //<- Only touch this number if `keylogger` array also changes
	/**/			for (a in 0...length) {
	/**/				caseheader += '_, ';
	/**/			}
	/**/			for (a in 0...cheatcode.length) {
	/**/				caseheader += '"' + cheatcode.substr(a, 1) + '", ';
	/**/			}
	/**/			caseheader = caseheader.substring(0, caseheader.length - 2);
	/**/			caseheader += '] :';
	/**/			
	/**/			var actionblock:String = '';
	/**/			
	/**/			var scripts:Array<Dynamic> = cast(currentcheat, Array<Dynamic>);
	/**/			
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//DO NOT TOUCH ANY OF THIS ABOVE
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//This part might turn into a macro itself. Who knows.
				for (actions in scripts) {
					var actionstring:String = cast(actions, String);
					switch (cast(actions, String)) {
						case "logplayerposition" :
							actionblock += 'GameActions.cheat_logPlayerPosition();';
						case "pseudoinvul" :
							actionblock += 'GameActions.cheat_degreeless();';
						default :
							var act = "" + actions;
							actionblock += 'trace("case not handled: $actionstring");';
					}
				}
				
				switch_block.insert(4, caseheader); //<-- Don't change these integers what so ever.
				switch_block.insert(5, actionblock);
			}
		}
		
		var code = switch_block.join("");
		
		return Context.parse(code, Context.currentPos());
	}
	public function doNothing(){};
	
	static var json_cheat:String = '{
	"doom": {
		"iddqd": [
      "pseudoinvul"
    ],
    "idspispopd": [
      "disablecollision"
    ],
    "idclip": [
      "disablecollision"
    ],
    "idkfa": [
      "grantfullammo",
      "grantallweapons",
      "grantfullhealth",
      "grantfullarmor",
      "grantallkeys"
    ],
    "idfa": [
      "grantfullammo",
      "grantweapons",
      "grantfullhealth",
      "grantfullarmor"
    ],
    "idclev": [
      "anticipatelevelchange"
    ],
    "idmus": [
      "anticipatemusicchange"
    ],
    "idbehold": [
      "anticipatekitemgive"
    ],
    "idchoppers": [
      "grantitem:doomchainsaw"
    ],
    "iddt": [
      "cyclemapdetail"
    ],
    "idmypos": [
      "logplayerposition"
    ],
    "fhall": [
      "killall:enemies"
    ],
    "fhshh": [
      "makeblind:enemies"
    ]
	}
	}';
}