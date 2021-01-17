package hxdoom.typedefs.properties;

/**
 * @author Kaelan
 */
typedef LineDefFlags =
{
	@:optional var blocking:Bool;
	@:optional var blockMonsters:Bool;
	@:optional var twoSided:Bool;
	@:optional var dontPegTop:Bool;
	@:optional var dontPegBottom:Bool;
	@:optional var secret:Bool;
	@:optional var soundBlock:Bool;
	@:optional var dontDraw:Bool;
	@:optional var mapped:Bool;
}