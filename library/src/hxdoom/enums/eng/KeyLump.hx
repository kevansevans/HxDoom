package hxdoom.enums.eng;

/**
 * @author Kaelan
 * 
 * Key Lumps are lumps that posses namespaces that easily point to their intended behavior.
 */
enum abstract KeyLump(String) from String
{
	var BLOCKMAP:String; //= "BLOCKMAP";
	var LINEDEFS:String; //= "LINEDEFS"; etcetera
	var NODES:String;
	var PLAYPAL:String;
	var REJECT:String;
	var SEGS:String;
	var SIDEDEFS:String;
	var SECTORS:String;
	var SSECTORS:String;
	var THINGS:String;
	var VERTEXES:String;
}