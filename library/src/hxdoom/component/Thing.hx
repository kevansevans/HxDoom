package hxdoom.component;

import hxdoom.enums.eng.Direction.CardInt;
import hxdoom.enums.eng.Direction.CardString;

/**
 * ...
 * @author Kaelan
 */
class Thing
{
	public static var CONSTRUCTOR:(Array<Any>) -> Thing = Thing.new;
	
	public var xpos:Int;
	public var ypos:Int;
	public var angle:Int;
	public var type:Int;
	public var flags:Int;
	public function new(_args:Array<Any>) 
	{
		xpos = 	_args[0];
		ypos = 	_args[1];
		angle = _args[2];
		type = 	_args[3];
		flags = _args[4];
	}
	
	public function toString():String {
		return([	'Position {x :' + xpos + ', y: ' + ypos + '}, ',
					'Direction {Angle: ' + angle + ', Cardinal: '  + cardinality(angle) + '}, ',
					'Type: {ThingID: ' + type + '}, ',
					'Flags: {' + flags + '}'
		
		].join(""));
	}
	
	public function cardinality(_angle:Int):String {
		switch (_angle) {
			case CardInt.EAST | CardInt.EAST2:
				return CardString.EAST;
			case CardInt.NORTHEAST:
				return CardString.NORTHEAST;
			case CardInt.NORTH:
				CardString.NORTH;
			case CardInt.NORTHWEST:
				return CardString.NORTHWEST;
			case CardInt.WEST:
				return CardString.WEST;
			case CardInt.SOUTHWEST:
				return CardString.SOUTHWEST;
			case CardInt.SOUTH: 
				return CardString.SOUTH;
			case CardInt.SOUTHEAST:
				return CardString.SOUTHEAST;
			default:
				return "Corrupt Direction, this should NEVER happen";
		}
		
		return "Corrupt Direction, this should NEVER happen. This is only here so the compiler doesn't freak out, BUT STILL SHOULD NEVER HAPPEN: " + angle;
	}
}
/*
typedef Thing = {
	var xpos:Int;
	var ypos:Int;
	var angle:Int;
	var type:Int;
	var flags:Int;
}
*/