package game.actor;

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
 * Doom doesn't explicitly categorize these items, they all sort of just exist. For the sake of source clarity and approaching
 * a ZDoom like experience, these will have to be categorized by hand. Inheritance should only be used for default flag control.
 * Emphasis on "ZDoom like", this ain't going to be zdoom or a ZDoom competitor. Just SOURCE friendly. Hopefully.
 * 
 */
enum abstract Doom(Int) from Int
{
	var PLAYERONE:Int = 1; //= 1 initializes the enums correctly, each var further on incriments by one. If there's a jump in value, that needs to be explicitly set. See W_SHOTGUN below.
	var PLAYERTWO:Int; //= 2
	var PLAYERTHREE:Int; //= 3
	var PLAYERFOUR:Int; //= 4, etcetera
	var BLUEKEYCARD:Int;
	var YELLOWKEYCARD:Int;
	var SPIDERMASTERMIND:Int;
	var BACKPACK:Int;
	var FORMERSERGEANT:Int;
	var BLOODYMESS0:Int;
	var DEATHMATCHSTART:Int;
	var BLOODYMESS1:Int;
	var REDKEYCARD:Int;
	var TELEPORTLANDING:Int;
	var DEADPLAYER:Int;
	var CYBERDEMON:Int;
	var CELLCHARGEPACK:Int;
	var DEADFORMERHUMAN:Int;
	var DEADFORMERSERGEANT:Int;
	var DEADIMP:Int;
	var DEADDEMON:Int;
	var DEADCACODEMON:Int;
	var DEADLOSTSOUL:Int;
	var POOLOFBLOODANDFLESH:Int;
	var IMPALEDHUMAN:Int;
	var IMPALEDTWITCHINGHUMAN:Int;
	var SKULLONAPOLE:Int;
	var SKULLSHISHKEBAB:Int;
	var PILEOFSKULLANDCANDLES:Int;
	var TALLGREENPILLAR:Int;
	var SHORTGREENPILLAR:Int;
	var TALLREDPILLAR:Int;
	var SHORTREDPILLAR:Int;
	var CANDLE:Int;
	var CANDELABRA:Int;
	var SHORTGREENPILLARWITHHEART:Int;
	var SHORTREDPILLARWITHSKULL:Int;
	var BLUESKULLKEY:Int;
	var YELLOWSKULLKEY:Int;
	var REDSKULLKEY:Int;
	var EVILEYE:Int;
	var FLOATINGSKULL:Int;
	var BURNTTREE:Int;
	var TALLBLUEFIRESTICK:Int;
	var TALLGREENFIRESTICK:Int;
	var TALLREDFIRESTICK:Int;
	var STALAGMITE:Int;
	var TALLTECHNOPILLAR:Int;
	var HANGINGVICTIMTWITCHING0:Int;
	var HANGINGVICTIMARMSOUT0:Int;
	var HANGINGVICTIMONELEG0:Int;
	var HANGINGPAIROFLEGS0:Int;
	var HANGINGLEG0:Int;
	var LARGEBROWNTREE:Int;
	var SHORTBLUEFIRESTICK:Int;
	var SHORTGREENFIRESTICK:Int;
	var SHORTREDFIRESTICK:Int;
	var SPECTRE:Int;
	var HANGINGVICTIMARMSOUT1:Int;
	var HANGINGPAIROFLEGS1:Int;
	var HANGINGVICTIMONELEG1:Int;
	var HANGINGLEG1:Int;
	var HANGINGVICTIMTWITCHING1:Int;
	var ARCHVILE:Int;
	var FORMERCOMMANDO:Int;
	var REVENANT:Int;
	var MANCUBUS:Int;
	var ARACHNOTRON:Int;
	var HELLKNIGHT:Int;
	var BURNINGBARREL:Int;
	var PAINELEMENTAL:Int;
	var COMMANDERKEEN:Int;
	var HANGINGVICTIMGUTSREMOVED:Int;
	var HANGINGVICTIMGUTSANDBRAINREMOVED:Int;
	var HANGINGTORSOLOOKINGDOWN:Int;
	var HANGINGTORSOOPENSKULL:Int;
	var HANGINGTORSOLOOKINGUP:Int;
	var HANGINGVTORSOBRAINREMOVED:Int;
	var POOLOFBLOOD0:Int;
	var POOLOFBLOOD1:Int;
	var POOLOFBRAINS:Int;
	var SUPERSHOTGUN:Int;
	var MEGASPHERE:Int;
	var WOLFSS:Int;
	var TALLTECHNOFLOORLAMP:Int;
	var SHORTTECHNOFLOORLAMP:Int;
	var SPAWNSPOT:Int; //= 87
	var BOSSBRAIN:Int; //= 88
	var BOSSSHOOTER:Int; //= 89
	var SHOTGUN:Int = 2001; 
	var CHAINGUN:Int; //= 2002
	var ROCKETLAUNCHER:Int; //= 2003
	var PLASMARIFLE:Int; //= 2004, etcetera
	var CHAINSAW:Int;
	var BFK9000:Int;
	var AMMOCLIP:Int;
	var SHOTGUNSHELLS:Int;
	var ROCKET:Int;
	var STIMPACK:Int;
	var MEDIKIT:Int;
	var SOULSPHERE:Int;
	var HEALTHPOTION:Int;
	var SPIRITARMOR:Int;
	var GREENARMOR:Int;
	var BLUEARMOR:Int;
	var INVULNERABILITY:Int;
	var BERSERK:Int;
	var INVISIBILITY:Int;
	var RADIATIONSUIT:Int;
	var COMPUTERMAP:Int;
	var FLOORLAMP:Int;
	var BARREL:Int;
	var LIGHTAMPLIFICATIONVISOR:Int;
	var BOXOFROCKETS:Int;
	var CELLCHARGE:Int; //= 2047
	var BOXOFAMMO:Int; //= 2048
	var BOXOFSHELLS:Int; //=2049
	var IMP:Int = 3001;
	var DEMON:Int; //= 3002
	var BARONOFHELL:Int; //= 3003
	var FORMERTROOPER:Int; //= 3004, etcetera
	var CACODEMON:Int;
	var LOSTSOUL:Int;
}