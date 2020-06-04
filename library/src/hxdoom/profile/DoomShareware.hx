package hxdoom.profile;

import hxdoom.core.ProfileCore;
import hxdoom.core.CVarCore;
import hxdoom.utils.enums.data.CVarType;
import hxdoom.utils.enums.data.Defaults;

/**
 * ...
 * @author Kaelan
 */
class DoomShareware extends ProfileCore 
{

	public function new() 
	{
		super();
					
		
		CVarCore.setCVar(Defaults.ALLOW_PWADS, false);
	}
	
}