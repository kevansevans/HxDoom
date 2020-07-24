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
	var P_PLAYERONE:Int = 1; //= 1 initializes the enums correctly, each var further on incriments by one. If there's a jump in value, that needs to be explicitly set. See W_SHOTGUN below.
	var P_PLAYERTWO:Int; //= 2
	var P_PLAYERTHREE:Int; //= 3
	var P_PLAYERFOUR:Int; //= 4, etcetera
	var I_BLUEKEYCARD:Int;
	var I_YELLOWKEYCARD:Int;
	var M_SPIDERMASTERMIND:Int;
	var I_BACKPACK:Int;
	var M_FORMERSERGEANT:Int;
	var D_BLOODYMESS0:Int;
	var P_DEATHMATCHSTART:Int;
	var D_BLOODYMESS1:Int;
	var I_REDKEYCARD:Int;
	var T_TELEPORTLANDING:Int;
	var P_DEADPLAYER:Int;
	var M_CYBERDEMON:Int;
	var I_CELLCHARGEPACK:Int;
	var M_DEADFORMERHUMAN:Int;
	var M_DEADFORMERSERGEANT:Int;
	var M_DEADIMP:Int;
	var M_DEADDEMON:Int;
	var M_DEADCACODEMON:Int;
	var M_DEADLOSTSOUL:Int;
	var D_POOLOFBLOODANDFLESH:Int;
	var D_IMPALEDHUMAN:Int;
	var D_IMPALEDTWITCHINGHUMAN:Int;
	var D_SKULLONAPOLE:Int;
	var D_SKULLSHISHKEBAB:Int;
	var D_PILEOFSKULLANDCANDLES:Int;
	var D_TALLGREENPILLAR:Int;
	var D_SHORTGREENPILLAR:Int;
	var D_TALLREDPILLAR:Int;
	var D_SHORTREDPILLAR:Int;
	var D_CANDLE:Int;
	var D_CANDELABRA:Int;
	var D_SHORTGREENPILLARWITHHEART:Int;
	var D_SHORTREDPILLARWITHSKULL:Int;
	var I_BLUESKULLKEY:Int;
	var I_YELLOWSKULLKEY:Int;
	var I_REDSKULLKEY:Int;
	var D_EVILEYE:Int;
	var D_FLOATINGSKULL:Int;
	var D_BURNTTREE:Int;
	var D_TALLBLUEFIRESTICK:Int;
	var D_TALLGREENFIRESTICK:Int;
	var D_TALLREDFIRESTICK:Int;
	var D_STALAGMITE:Int;
	var D_TALLTECHNOPILLAR:Int;
	var D_HANGINGVICTIMTWITCHING0:Int;
	var D_HANGINGVICTIMARMSOUT0:Int;
	var D_HANGINGVICTIMONELEG0:Int;
	var D_HANGINGPAIROFLEGS0:Int;
	var D_HANGINGLEG0:Int;
	var D_LARGEBROWNTREE:Int;
	var D_SHORTBLUEFIRESTICK:Int;
	var D_SHORTGREENFIRESTICK:Int;
	var D_SHORTREDFIRESTICK:Int;
	var M_SPECTRE:Int;
	var D_HANGINGVICTIMARMSOUT1:Int;
	var D_HANGINGPAIROFLEGS1:Int;
	var D_HANGINGVICTIMONELEG1:Int;
	var D_HANGINGLEG1:Int;
	var D_HANGINGVICTIMTWITCHING1:Int;
	var M_ARCHVILE:Int;
	var M_FORMERCOMMANDO:Int;
	var M_REVENANT:Int;
	var M_MANCUBUS:Int;
	var M_ARACHNOTRON:Int;
	var M_HELLKNIGHT:Int;
	var D_BURNINGBARREL:Int;
	var M_PAINELEMENTAL:Int;
	var M_COMMANDERKEEN:Int;
	var D_HANGINGVICTIMGUTSREMOVED:Int;
	var D_HANGINGVICTIMGUTSANDBRAINREMOVED:Int;
	var D_HANGINGTORSOLOOKINGDOWN:Int;
	var D_HANGINGTORSOOPENSKULL:Int;
	var D_HANGINGTORSOLOOKINGUP:Int;
	var D_HANGINGVTORSOBRAINREMOVED:Int;
	var D_POOLOFBLOOD0:Int;
	var D_POOLOFBLOOD1:Int;
	var D_POOLOFBRAINS:Int;
	var W_SUPERSHOTGUN:Int;
	var I_MEGASPHERE:Int;
	var M_WOLFSS:Int;
	var D_TALLTECHNOFLOORLAMP:Int;
	var D_SHORTTECHNOFLOORLAMP:Int;
	var M_SPAWNSPOT:Int; //= 87
	var M_BOSSBRAIN:Int; //= 88
	var M_BOSSSHOOTER:Int; //= 89
	var W_SHOTGUN:Int = 2001; 
	var W_CHAINGUN:Int; //= 2002
	var W_ROCKETLAUNCHER:Int; //= 2003
	var W_PLASMARIFLE:Int; //= 2004, etcetera
	var W_CHAINSAW:Int;
	var W_BFK9000:Int;
	var I_AMMOCLIP:Int;
	var I_SHOTGUNSHELLS:Int;
	var I_ROCKET:Int;
	var I_STIMPACK:Int;
	var I_MEDIKIT:Int;
	var I_SOULSPHERE:Int;
	var I_HEALTHPOTION:Int;
	var I_SPIRITARMOR:Int;
	var I_GREENARMOR:Int;
	var I_BLUEARMOR:Int;
	var I_INVULNERABILITY:Int;
	var I_BERSERK:Int;
	var I_INVISIBILITY:Int;
	var I_RADIATIONSUIT:Int;
	var I_COMPUTERMAP:Int;
	var D_FLOORLAMP:Int;
	var D_BARREL:Int;
	var I_LIGHTAMPLIFICATIONVISOR:Int;
	var I_BOXOFROCKETS:Int;
	var I_CELLCHARGE:Int; //= 2047
	var I_BOXOFAMMO:Int; //= 2048
	var I_BOXOFSHELLS:Int; //=2049
	var M_IMP:Int = 3001;
	var M_DEMON:Int; //= 3002
	var M_BARONOFHELL:Int; //= 3003
	var M_FORMERTROOPER:Int; //= 3004, etcetera
	var M_CACODEMON:Int;
	var M_LOSTSOUL:Int;
}