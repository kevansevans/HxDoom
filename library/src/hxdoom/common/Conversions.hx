package hxdoom.common;

import hxdoom.utils.enums.Level;

/**
 * ...
 * @author Kaelan
 */
class Conversions 
{

	public function new() 
	{
		
	}
	/**
	 * Turn integer into Map String
	 * @param	_value
	 * @return
	 */
	public static function levelIntToLevelString(_value:Int):String {
		switch (_value) {
			case Level.E1M1 :
				return("E1M1");
			case Level.E1M2 :
				return("E1M2");
			case Level.E1M3 :
				return("E1M3");
			case Level.E1M4 :
				return("E1M4");
			case Level.E1M5 :
				return("E1M5");
			case Level.E1M6 :
				return("E1M6");
			case Level.E1M7 :
				return("E1M7");
			case Level.E1M8 :
				return("E1M8");
			case Level.E1M9 :
				return("E1M9");
				
			case Level.E2M1 :
				return("E2M1");
			case Level.E2M2 :
				return("E2M2");
			case Level.E2M3 :
				return("E2M3");
			case Level.E2M4 :
				return("E2M4");
			case Level.E2M5 :
				return("E2M5");
			case Level.E2M6 :
				return("E2M6");
			case Level.E2M7 :
				return("E2M7");
			case Level.E2M8 :
				return("E2M8");
			case Level.E2M9 :
				return("E2M9");
				
			case Level.E3M1 :
				return("E3M1");
			case Level.E3M2 :
				return("E3M2");
			case Level.E3M3 :
				return("E3M3");
			case Level.E3M4 :
				return("E3M4");
			case Level.E3M5 :
				return("E3M5");
			case Level.E3M6 :
				return("E3M6");
			case Level.E3M7 :
				return("E3M7");
			case Level.E3M8 :
				return("E3M8");
			case Level.E3M9 :
				return("E3M9");
				
			case Level.E4M1 :
				return("E4M1");
			case Level.E4M2 :
				return("E4M2");
			case Level.E4M3 :
				return("E4M3");
			case Level.E4M4 :
				return("E4M4");
			case Level.E4M5 :
				return("E4M5");
			case Level.E4M6 :
				return("E4M6");
			case Level.E4M7 :
				return("E4M7");
			case Level.E4M8 :
				return("E4M8");
			case Level.E4M9 :
				return("E4M9");
				
			default :
				return("NaM");
		}
	}
	
}