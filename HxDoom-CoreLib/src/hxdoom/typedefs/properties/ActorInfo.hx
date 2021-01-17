package hxdoom.typedefs.properties;

/**
 * @author Kaelan
 */
typedef ActorInfo =
{
	@:optional var spawnState:ActorState;	
	@:optional var seeState:ActorState;	
	@:optional var painState:ActorState;	
	@:optional var meleeState:ActorState; //afaik melee is the only optional one here, may change in the future
	@:optional var missileState:ActorState;
	@:optional var deathState:ActorState;
	@:optional var xdeathState:ActorState;
	@:optional var radius:Float;
	@:optional var height:Float;
	@:optional var doomednum:Int;
	@:optional var spawnhealth:Int;
	@:optional var painchance:Int;
	@:optional var mass:Int;
	@:optional var speed:Int;
	@:optional var reactionTime:Int;
	@:optional var damage:Int;
	@:optional var seeSound:Int;
	@:optional var attackSound:Int;
	@:optional var painSound:Int;
	@:optional var deathSound:Int;
	@:optional var activeSound:Int;
}