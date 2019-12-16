package render.gl.enums;

/**
 * @author Kaelan
 */

//We'll use implicit string casts to make this easier outside of this class.
enum abstract Automap(String) from String {
	var V3_POSITION:String;
	var V3_COLOR:String;
	var F_COLOR:String;
	var M4_POSITION:String;
}