package hxdoom.core.action;
import hxdoom.Engine;
import hxdoom.component.Actor;
import hxdoom.core.Defines;
import hxdoom.core.action.Map;
import hxdoom.lumps.map.LineDef;

/**
 * ...
 * @author Kaelan
 */
class Move 
{

	public static var oldx:Float;
	public static var oldy:Float;
	
	public static var tmfloorz:Float;
	public static var tmceilingz:Float;
	
	public static var movething:Actor;
	
	public static var blockline:LineDef;
	
	public static var tryMove2:Void -> Void = tryMove2Default;
	public static function tryMove2Default():Void
	{
		Defines.trymove2 = false;
		Defines.floatok = false;
		
		oldx = Map.tmthing.xpos * -1;
		oldy = Map.tmthing.ypos;
		
		//Map.checkPosition();
		
		if (Map.checkposonly) {
			Map.checkposonly = false;
			return;
		}
		
		if (!Defines.trymove2) return;
		
		if (!Map.tmthing.flags.noclip) {
			Defines.trymove2 = false;
			
			if (tmceilingz - tmfloorz < Map.tmthing.health) return;
			
			Defines.floatok = true;
			
			if (!Map.tmthing.flags.teleport  
				&& tmceilingz - Map.tmthing.zpos < Map.tmthing.health) return;
				
			if (!Map.tmthing.flags.teleport  
				&& tmfloorz - Map.tmthing.zpos > 24) return;
				
			if ((Map.tmthing.flags.dropoff ||  Map.tmthing.flags.float) 
				&& tmfloorz - Map.tmthing.zpos > 24) return;
		}
		
		//remove from blockmap or whatever
		Engine.log(["unfinished here"]);
		
		//Map.tmthing.floorz = tmfloorz;
		//Map.tmthing.ceilingz = tmceilingz;
		//Map.tmthing.x = tmx;
		//Map.tmthing.y = tmy;
		
		//put back in blockmap
		
		Defines.trymove2 = true;
	}
	
}