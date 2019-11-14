package packages.actors;

/**
 * @author Kaelan
 * Try to keep this in numerical order.
 * 
 * P_: Player/deathmatch/Multiplayer
 * I_: Item
 * T_: Teleporter
 * W_: Weapon
 * M_: Monster
 * D_: Decoration
 * 
 */
enum abstract TypeID(Int) from Int
{
	public var P_PLAYERONE:Int = 1; //= 1 initializes the enums correctly, each var further on incriments by one
	public var P_PLAYERTWO:Int; //= 2
	public var P_PLAYERTHREE:Int; //= 3
	public var P_PLAYERFOUR:Int; //= 4, etcetera
	public var I_BLUEKEYCARD:Int;
	public var I_YELLOWKEYCARD:Int;
	public var M_SPIDERMASTERMIND:Int;
	public var I_BACKPACK:Int;
	public var M_FORMERSERGEANT:Int;
	public var D_BLOODYMESS0:Int;
	public var P_DEATHMATCHSTART:Int;
	public var D_BLOODYMESS1:Int;
	public var I_REDKEYCARD:Int;
	public var T_TELEPORTLANDING:Int;
	public var P_DEADPLAYER:Int;
	public var M_CYBERDEMON:Int;
	public var I_CELLCHARGEPACK:Int;
	public var M_DEADFORMERHUMAN:Int;
	public var M_DEADFORMERSERGEANT:Int;
	public var M_DEADIMP:Int;
	public var M_DEADDEMON:Int;
	public var M_DEADCACODEMON:Int;
	public var M_DEADLOSTSOUL:Int;
	public var D_POOLOFBLOODANDFLESH:Int;
	public var D_IMPALEDHUMAN:Int;
	public var D_IMPALEDTWITCHINGHUMAN:Int;
	public var D_SKULLONAPOLE:Int;
	public var D_SKULLSHISHKEBAB:Int;
	public var D_PILEOFSKULLANDCANDLES:Int;
	public var D_TALLGREENPILLAR:Int;
	public var D_SHORTGREENPILLAR:Int;
	public var D_TALLREDPILLAR:Int;
	public var D_SHORTREDPILLAR:Int;
	public var D_CANDLE:Int;
	public var D_CANDELABRA:Int;
	public var D_SHORTGREENPILLARWITHHEART:Int;
	public var D_SHORTREDPILLARWITHSKULL:Int;
	public var I_BLUESKULLKEY:Int;
	public var I_YELLOWSKULLKEY:Int;
	public var I_REDSKULLKEY:Int;
	public var D_EVILEYE:Int;
	public var D_FLOATINGSKULL:Int;
	public var D_BURNTTREE:Int;
	public var D_TALLBLUEFIRESTICK:Int;
	public var D_TALLGREENFIRESTICK:Int;
	public var D_TALLREDFIRESTICK:Int;
	public var D_STALAGMITE:Int;
	public var D_TALLTECHNOPILLAR:Int;
	public var D_HANGINGVICTIMTWITCHING0:Int;
	public var D_HANGINGVICTIMARMSOUT0:Int;
	public var D_HANGINGVICTIMONELEG0:Int;
	public var D_HANGINGPAIROFLEGS0:Int;
	public var D_HANGINGLEG0:Int;
	public var D_LARGEBROWNTREE:Int;
	public var D_SHORTBLUEFIRESTICK:Int;
	public var D_SHORTGREENFIRESTICK:Int;
	public var D_SHORTREDFIRESTICK:Int;
	public var M_SPECTRE:Int;
	public var D_HANGINGVICTIMARMSOUT1:Int;
	public var D_HANGINGPAIROFLEGS1:Int;
	public var D_HANGINGVICTIMONELEG1:Int;
	public var D_HANGINGLEG1:Int;
	public var D_HANGINGVICTIMTWITCHING1:Int;
	public var M_ARCHVILE:Int;
	public var M_FORMERCOMMANDO:Int;
	public var M_REVENANT:Int;
	public var M_MANCUBUS:Int;
	public var M_ARACHNOTRON:Int;
	public var M_HELLKNIGHT:Int;
	public var D_BURNINGBARREL:Int;
	public var M_PAINELEMENTAL:Int;
	public var M_COMMANDERKEEN:Int;
	public var D_HANGINGVICTIMGUTSREMOVED:Int;
	public var D_HANGINGVICTIMGUTSANDBRAINREMOVED:Int;
	public var D_HANGINGTORSOLOOKINGDOWN:Int;
	public var D_HANGINGTORSOOPENSKULL:Int;
	public var D_HANGINGTORSOLOOKINGUP:Int;
	public var D_HANGINGVTORSOBRAINREMOVED:Int;
	public var D_POOLOFBLOOD0:Int;
	public var D_POOLOFBLOOD1:Int;
	public var D_POOLOFBRAINS:Int;
	public var W_SUPERSHOTGUN:Int;
	public var I_MEGASPHERE:Int;
	public var M_WOLFSS:Int;
	public var D_TALLTECHNOFLOORLAMP:Int;
	public var D_SHORTTECHNOFLOORLAMP:Int;
	public var M_SPAWNSPOT:Int; //= 87
	public var M_BOSSBRAIN:Int; //= 88
	public var M_BOSSSHOOTER:Int; //= 89
	public var W_SHOTGUN:Int = 2001; 
	public var W_CHAINGUN:Int; //= 2002
	public var W_ROCKETLAUNCHER:Int; //= 2003
	public var W_PLASMARIFLE:Int; //= 2004, etcetera
	public var W_CHAINSAW:Int;
	public var W_BFK9000:Int;
	public var I_AMMOCLIP:Int;
	public var I_SHOTGUNSHELLS:Int;
	public var I_ROCKET:Int;
	public var I_STIMPACK:Int;
	public var I_MEDIKIT:Int;
	public var I_SOULSPHERE:Int;
	public var I_HEALTHPOTION:Int;
	public var I_SPIRITARMOR:Int;
	public var I_GREENARMOR:Int;
	public var I_BLUEARMOR:Int;
	public var I_INVULNERABILITY:Int;
	public var I_BERSERK:Int;
	public var I_INVISIBILITY:Int;
	public var I_RADIATIONSUIT:Int;
	public var I_COMPUTERMAP:Int;
	public var D_FLOORLAMP:Int;
	public var D_BARREL:Int;
	public var I_LIGHTAMPLIFICATIONVISOR:Int;
	public var I_BOXOFROCKETS:Int;
	public var I_CELLCHARGE:Int; //= 2047
	public var I_BOXOFAMMO:Int; //= 2048
	public var I_BOXOFSHELLS:Int; //=2049
	public var M_IMP:Int = 3001;
	public var M_DEMON:Int; //= 3002
	public var M_BARONOFHELL:Int; //= 3003
	public var M_FORMERTROOPER:Int; //= 3004, etcetera
	public var M_CACODEMON:Int;
	public var M_LOSTSOUL:Int;
}