package hxdoom.profile;

import hxdoom.core.ProfileCore;
import hxdoom.core.CVarCore;
import hxdoom.utils.enums.CVarType;
import hxdoom.utils.enums.Defaults;

/**
 * ...
 * @author Kaelan
 */
class DoomShareware extends ProfileCore 
{

	public function new() 
	{
		super();
		
		contains = ["E1M1",
					"E1M2",
					"E1M3",
					"E1M4",
					"E1M5",
					"E1M6",
					"E1M7",
					"E1M8",
					"E1M9"];
					
		
		CVarCore.setCVar(Defaults.ALLOW_PWADS, false);
	}
	
}