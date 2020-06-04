package hxdoom.lumps.map;

import hxdoom.utils.enums.eng.CardinalDirection.CardInt;
import hxdoom.utils.enums.eng.CardinalDirection.CardString;

/**
 * ...
 * @author Kaelan
 */
class Thing 
{
	public var xpos:Int;
	public var ypos:Int;
	public var angle:Int;
	public var type:Int;
	public var flags:Int;
	public function new(_xpos:Int, _ypos:Int, _angle:Int, _type:Int, _flags:Int) 
	{
		xpos = _xpos;
		ypos = _ypos;
		angle = _angle;
		type = _type;
		flags = _flags;
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