package hxdoom.core.action;

import hxdoom.component.Actor;
import hxdoom.lumps.map.LineDef;
import hxdoom.enums.game.SharedEdNum;
import hxdoom.component.Player;
import hxdoom.enums.game.LineFlags;
import hxdoom.enums.eng.StairType;

/**
 * ...
 * @author Kaelan
 */
class Switch //p_switch.c
{

	public static var UseSpecialLine:(Actor, LineDef, Int) -> Bool = P_UseSpecialLine;
	public static function P_UseSpecialLine(_actor:Actor, _line:LineDef, _side:Int):Bool
	{
		Engine.log(["Not finished here, soooo not finished here"]);
		
		//Do I keep this...?
		if (_side == 1) {
			switch (_line.lineType) {
				case 124:
					//sliding door unused code here, fun fact!
				default :
					
			}
		}
		
		//Double check that this works, a bool can easily be supstituted here if not
		if (!_actor.isPlayer) {
			if (_line.flags & LineFlags.SECRET > 0) return false;
			
			switch (_line.lineType) {
				case 1 | 32 | 33 | 34 :
					
				default :
					return false;
			}
		}
		
		//Todo: Convert these numbers of line types into Enums.
		
		switch (_line.lineType) {
			case 1 | 26 | 27 | 28 | 31 | 32 | 33 | 34 | 117 | 118 :
				Doors.VerticalDoor(_line, _actor);
				
			case 7 :
				if (Floor.BuildStairs(_line, StairType.build8) > 0) {
					//changeSwitchTexture
					Engine.log(["Not finished here"]);
				}
			case 9 :
				//it's spelled doughnut you hecking savages
				Engine.log(["Not finished here"]);
			case 11 :
				//Exit level
				Engine.log(["Not finished here"]);
			case 14 :
				Engine.log(["Not finished here"]);
			case 15 :
				Engine.log(["Not finished here"]);
			case 18 :
				Engine.log(["Not finished here"]);
			case 20 :
				Engine.log(["Not finished here"]);
			case 21 :
				Engine.log(["Not finished here"]);
			case 23 :
				Engine.log(["Not finished here"]);
			case 29 :
				Engine.log(["Not finished here"]);
			case 41 :
				Engine.log(["Not finished here"]);
			case 71 :
				Engine.log(["Not finished here"]);
			case 49 :
				Engine.log(["Not finished here"]);
			case 50 :
				Engine.log(["Not finished here"]);
			case 51 :
				Engine.log(["Not finished here"]);
			case 55 :
				Engine.log(["Not finished here"]);
			case 101 :
				Engine.log(["Not finished here"]);
			case 102 :
				Engine.log(["Not finished here"]);
			case 103 :
				Engine.log(["Not finished here"]);
			case 111 :
				Engine.log(["Not finished here"]);
			case 112 :
				Engine.log(["Not finished here"]);
			case 113 :
				Engine.log(["Not finished here"]);
			case 122 :
				Engine.log(["Not finished here"]);
			case 127 :
				Engine.log(["Not finished here"]);
			case 131 :
				Engine.log(["Not finished here"]);
			case 133 | 135 | 137 :
				Engine.log(["Not finished here"]);
			case 140 :
				Engine.log(["Not finished here"]);
			case 42 :
				Engine.log(["Not finished here"]);
			case 43 :
				Engine.log(["Not finished here"]);
			case 45 :
				Engine.log(["Not finished here"]);
			case 60 :
				Engine.log(["Not finished here"]);
			case 61 :
				Engine.log(["Not finished here"]);
			case 62 :
				Engine.log(["Not finished here"]);
			case 63 :
				Engine.log(["Not finished here"]);
			case 64 :
				Engine.log(["Not finished here"]);
			case 66 : 
				Engine.log(["Not finished here"]);
			case 67 :
				Engine.log(["Not finished here"]);
			case 65 :
				Engine.log(["Not finished here"]);
			case 68 :
				Engine.log(["Not finished here"]);
			case 69 :
				Engine.log(["Not finished here"]);
			case 70 :
				Engine.log(["Not finished here"]);
			case 114 :
				Engine.log(["Not finished here"]);
			case 115 :
				Engine.log(["Not finished here"]);
			case 116 :
				Engine.log(["Not finished here"]);
			case 123 :
				Engine.log(["Not finished here"]);
			case 132 :
				Engine.log(["Not finished here"]);
			case 99 | 134 | 136 :
				Engine.log(["Not finished here"]);
			case 138 :
				Engine.log(["Not finished here"]);
			case 139 :
				Engine.log(["Not finished here"]);
			default :
				Engine.log(["Switch line type not recognized, please verify: " + _line.lineType]);
			
		}
		
		return false;
		
	}
	
}