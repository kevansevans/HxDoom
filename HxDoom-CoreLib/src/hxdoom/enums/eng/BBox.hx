package hxdoom.enums.eng;

/**
 * @author Kaelan
 * 
 * from https://github.com/Olde-Skuul/doom3do/blob/5713f6fd2a66338e0135d41e297de963652371af/source/doom.h#L218
 */
enum abstract BBox(Int) from Int to Int
{
	var BOXTOP:Int;
	var BOXBOTTOM:Int;
	var BOXLEFT:Int;
	var BOXRIGHT:Int;
	var BOXCOUNT:Int;
}