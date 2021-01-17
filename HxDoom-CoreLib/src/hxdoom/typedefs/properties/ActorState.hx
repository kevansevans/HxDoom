package hxdoom.typedefs.properties;

/**
 * @author Kaelan
 */
typedef ActorState =
{
	var spriteFrame:String;
	var time:Int;
	var action:Void -> Void;
	var nextState:ActorState;
}