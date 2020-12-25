package hxdoom.typedefs.properties;

/**
 * @author Kaelan
 * 
 * from https://github.com/Olde-Skuul/doom3do/blob/5713f6fd2a66338e0135d41e297de963652371af/source/doom.h#L317
 */
typedef ActorFlags =
{
	var ?special:Bool;
	var ?solid:Bool;
	var ?shootable:Bool;
	var ?nosector:Bool;
	var ?noblockmap:Bool;
	var ?ambush:Bool;
	var ?justhit:Bool;
	var ?justattacked:Bool;
	var ?spawnceiling:Bool;
	var ?nogravity:Bool;
	var ?dropoff:Bool;
	var ?pickup:Bool;
	var ?noclip:Bool;
	var ?slide:Bool;
	var ?float:Bool;
	var ?teleport:Bool;
	var ?missile:Bool;
	var ?dropped:Bool;
	var ?shadow:Bool;
	var ?noblood:Bool;
	var ?corpse:Bool;
	var ?infloat:Bool;
	var ?countkill:Bool;
	var ?countitem:Bool;
	var ?skullfly:Bool;
	var ?notdeathmatch:Bool;
	var ?seetarget:Bool;
}