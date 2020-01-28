package hxdoom.abstracts;

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
abstract CheatCode(Array<String>) from Array<String>
{
	public inline function new(a:Array<String>) {
		this = a;
		this.resize(10);
	}
	
	@:arrayAccess
	public inline function arrayWrite(key:Int, val:String):Null<String> {
		this.insert(key, val.toLowerCase());
		this.resize(10);
		return checkCheat();
	}
	
	public static macro function checkCheat() {
		var preamble:Array<String> = new Array();
		
		//DO NOT TOUCH ANY OF THIS BELOW
		preamble = 	['{',
			'var log = this.copy();',
			'log.reverse();',
			'switch (log) {',
				'default :',
					'return null;',
			'}',
		'}'];
		//DO NOT TOUCH ANY OF THIS ABOVE
		
		var file = File.getBytes("./assets/json/cheats.txt");
		var codesheet:Dynamic = Json.parse(file.getString(0, file.length));
		
		for (item in Reflect.fields(codesheet.doom)) {
			var keycode:String = cast(item, String);
			var caseheader = 'case [';
			var length = 10 - keycode.length;
			for (a in 0...length) {
				caseheader += '_, ';
			}
			for (a in 0...keycode.length) {
				caseheader += '"' + keycode.substr(a, 1) + '", ';
			}
			caseheader = caseheader.substring(0, caseheader.length - 2);
			caseheader += '] :';
			var returnfooter = 'return "' + Reflect.field(codesheet.doom, item) + '";';
			
			preamble.insert(4, caseheader);
			preamble.insert(5, returnfooter);
		}
		
		var code = preamble.join("");
		
		return Context.parse(code, Context.currentPos());
	}
}