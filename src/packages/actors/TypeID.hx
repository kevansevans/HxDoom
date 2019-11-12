package packages.actors;

/**
 * @author Kaelan
 * Try to keep this in numerical order.
 * 
 */
enum abstract TypeID(Int) from Int
{
	public var PLAYERONE:Int = 1;
	public var PLAYERTWO:Int = 2;
	public var PLAYERTHREE:Int = 3;
	public var PLAYERFOUR:Int = 4;
	
	public var ARCHVILE:Int = 64;
	public var FORMERCOMMANDO:Int = 65;
	public var REVENANT:Int = 66;
	public var MANCUBUS:Int = 67;
	public var ARACHNOTRON:Int = 68;
	public var HELLKNIGHT:Int = 69;
	public var PAINELEMENTAL:Int = 71;
	public var WOLFSS:Int = 84;
	public var BOSSBRAIN:Int = 88;
	public var BOSSSHOOTER:Int = 89;
}