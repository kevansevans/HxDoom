package hxdoom.core.action;

import hxdoom.Engine;
import hxdoom.component.Actor;
import hxdoom.lumps.map.LineDef;

/**
 * ...
 * @author Kaelan
 */
class Switch 
{

	public static var useSpecialLine:(Actor, LineDef) -> Bool = useSpecialLineDefault;
	public static function useSpecialLineDefault(_actor:Actor, _line:LineDef):Bool
	{
		if (!_actor.isPlayer) {
			
			if (_line.flags.secret) {
				return false;
			}
			
			switch (_line.special) {
				default :
					return false;
				case 1 :
					// fall through and continue as normal...?
				case 32, 33, 34 :
					/*
					 * Interesting bit of code here. Original Doom performs this check
					 * a second time when opening a door, as monsters can not open locked
					 * doors. In the 3DO port, these three cases are omitted via a consitional
					 * set to always be false (#if 0). Reduces the check to 1, likely a bug fix
					 * or an optimization thing.
					 */
					
			}
		}
		
		switch (_line.special) {
			
			//Doors
			case 1, 26, 27, 28, 31, 32, 33, 34, 99, 100, 105, 104, 108, 107 :
				//regular door open
				
			//buttons
			case 42 :
				
			case 43 :
				
			case 45 :
				
			case 60 :
				
			case 61 :
				
			case 62 :
				
			case 63 :
				
			case 64 :
				
			case 65 :
				
			case 66 :
				
			case 67 :
				
			case 68 :
				
			case 69 :
				
			case 70 :
				
			//Switches (single use)
			case 7 :
				
			case 9 :
				
			case 11 :
				
			case 14 :
				
			case 15 :
				
			case 18 :
				
			case 20 :
				
			case 21 :
				
			case 23 :
				
			case 29 :
				
			case 41 :
				
			case 49 :
				
			case 50 :
				
			case 51 :
				
			case 55 :
				
			case 71 :
				
			case 101 :
				
			case 102 :
				
			case 103 :
				
			default :
				Engine.log(['Unhandled line special, please investigate: ${_line.special}']);
		}
		
		return true;
	}
	
}