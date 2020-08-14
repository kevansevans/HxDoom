package game.profiles.doom;

import hxdoom.Engine;
import hxdoom.core.ProfileCore;
import hxdoom.typedefs.data.EpisodeProperties;
import hxdoom.typedefs.data.MapProperties;

/**
 * ...
 * @author Kaelan
 */
class DoomShareware extends ProfileCore
{
	public var episodes:Array<EpisodeProperties> =
	[
		{
			index : 0,
			name : "Knee Deep in The Dead",
			firstLevel : 0
		}
	];
	public var maps:Array<MapProperties> = [
		{
			internalName : "E1M1",
			levelName : "Hangar",
			levelIndex : 0,
			nextMap : 1,
			nextMapSecret : 1,
			episodeEnd : false,
		},
		{
			internalName : "E1M2",
			levelName : "Nuclear Plant",
			levelIndex : 1,
			nextMap : 2,
			nextMapSecret : 2,
			episodeEnd : false,
		},
		{
			internalName : "E1M3",
			levelName : "Toxin Refinery",
			levelIndex : 2,
			nextMap : 3,
			nextMapSecret : 8,
			episodeEnd : false,
		},
		{
			internalName : "E1M4",
			levelName : "Command Control",
			levelIndex : 3,
			nextMap : 4,
			nextMapSecret : 4,
			episodeEnd : false,
		},
		{
			internalName : "E1M5",
			levelName : "Phobos Lab",
			levelIndex : 4,
			nextMap : 5,
			nextMapSecret : 5,
			episodeEnd : false,
		},
		{
			internalName : "E1M6",
			levelName : "Central Processing",
			levelIndex : 5,
			nextMap : 6,
			nextMapSecret : 6,
			episodeEnd : false,
		},
		{
			internalName : "E1M7",
			levelName : "Computer Station",
			levelIndex : 6,
			nextMap : 7,
			nextMapSecret : 7,
			episodeEnd : false,
		},
		{
			internalName : "E1M8",
			levelName : "Phobos Anomaly",
			levelIndex : 7,
			nextMap : 7,
			nextMapSecret : 7,
			episodeEnd : true,
		},
		{
			internalName : "E1M9",
			levelName : "Military Base",
			levelIndex : 8,
			nextMap : 3,
			nextMapSecret : 3,
			episodeEnd : false,
		},
	];
	public function new() 
	{
		super();
		
		Engine.LEVELS.episodeData = episodes;
		Engine.LEVELS.levelData = maps;
	}
	
}