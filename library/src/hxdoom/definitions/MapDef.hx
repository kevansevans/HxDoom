package hxdoom.definitions;

import haxe.ds.Either;

/**
 * @author Kaelan
 */
typedef MapDef =
{
	@:optional var internalName:String;
	@:optional var levelName:String;
	@:optional var levelIndex:Int;
	@:optional var nextMap:Int;
	@:optional var nextMapSecret:Int;
	@:optional var episodeEnd:Bool;
	@:optional var musicName:String;
}