package hxdoom.data;

/**
 * @author Kaelan
 * 
 * Using implicit casts just for the sake of autocomplete in my IDE
 */
enum abstract Lump(String) from String
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