package hxdoom.typedefs.data;

/**
 * @author Kaelan
 */
typedef MapProperties =
{
	@:optional var internalName:String;
	@:optional var levelName:String;
	@:optional var levelIndex:Int;
	@:optional var nextMap:Int;
	@:optional var nextMapSecret:Int;
	@:optional var episodeEnd:Bool;
}