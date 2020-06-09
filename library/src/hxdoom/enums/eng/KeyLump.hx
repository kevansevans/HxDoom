package hxdoom.enums.eng;

/**
 * @author Kaelan
 * 
 * Key Lumps are lumps that posses namespaces that easily point to their intended behavior.
 */
enum abstract KeyLump(String) from String to String
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
	var P_START:String;
	var P1_START:String;
	var P1_END:String;
	var P2_START:String;
	var P2_END:String;
	var P_END:String;
	var F_START:String;
	var F1_START:String;
	var F1_END:String;
	var F2_START:String;
	var F2_END:String;
	var F_END:String;
}