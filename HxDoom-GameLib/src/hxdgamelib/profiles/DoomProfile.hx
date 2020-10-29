package hxdgamelib.profiles;

import hxdoom.component.Actor;
import hxdoom.core.action.Enemy;
import hxdoom.core.action.Sight;
import hxdoom.core.action.MapUtils;
import hxdoom.core.ProfileCore;
import hxdoom.definitions.EpisodeDef;
import hxdoom.definitions.MapDef;
import hxdoom.Engine;
import hxdoom.enums.game.ActorFlags;
import hxdoom.utils.math.Fixed;

import hxdgamelib.enums.doom.DoomType;

/**
 * ...
 * @author Kaelan
 */
class DoomProfile extends ProfileCore 
{

	public var episodes:Array<EpisodeDef>;
	public var maps:Array<MapDef>;
	
	public function new(_shareware:Bool = true) 
	{
		super();
		
		episodes = new Array();
		
		episodes.push(
		{
			index : 0,
			name : "Knee Deep in The Dead",
			firstLevel : 0
		});
		
		maps = new Array();
		
		maps.push({
			internalName : "E1M1",
			levelName : "Hangar",
			levelIndex : 0,
			nextMap : 1,
			nextMapSecret : 1,
			episodeEnd : false,
		});
		maps.push({
			internalName : "E1M2",
			levelName : "Nuclear Plant",
			levelIndex : 1,
			nextMap : 2,
			nextMapSecret : 2,
			episodeEnd : false,
		});
		maps.push({
			internalName : "E1M3",
			levelName : "Toxin Refinery",
			levelIndex : 2,
			nextMap : 3,
			nextMapSecret : 8,
			episodeEnd : false,
		});
		maps.push({
			internalName : "E1M4",
			levelName : "Command Control",
			levelIndex : 3,
			nextMap : 4,
			nextMapSecret : 4,
			episodeEnd : false,
		});
		maps.push({
			internalName : "E1M5",
			levelName : "Phobos Lab",
			levelIndex : 4,
			nextMap : 5,
			nextMapSecret : 5,
			episodeEnd : false,
		});
		maps.push({
			internalName : "E1M6",
			levelName : "Central Processing",
			levelIndex : 5,
			nextMap : 6,
			nextMapSecret : 6,
			episodeEnd : false,
		});
		maps.push({
			internalName : "E1M7",
			levelName : "Computer Station",
			levelIndex : 6,
			nextMap : 7,
			nextMapSecret : 7,
			episodeEnd : false,
		});
		maps.push({
			internalName : "E1M8",
			levelName : "Phobos Anomaly",
			levelIndex : 7,
			nextMap : 7,
			nextMapSecret : 7,
			episodeEnd : true,
		});
		maps.push({
			internalName : "E1M9",
			levelName : "Military Base",
			levelIndex : 8,
			nextMap : 3,
			nextMapSecret : 3,
			episodeEnd : false,
		});
		
		if (!_shareware) {
			
			episodes.push(
			{
				index : 1,
				name : "The Shores of Hell",
				firstLevel : 9
			});
			episodes.push(
			{
				index : 2,
				name : "Inferno",
				firstLevel : 19
			});
			
			trace("to do: E2M1 through E4M9");
			
			if (Engine.WADDATA.wadContains(["E4M1", "E4M2", "E4M3", "E4M4", "E4M5", "E4M6", "E4M7", "E4M8", "E4M9"])) {
				episodes.push(
				{
					index : 3,
					name : "Thy Flesh Consumed",
					firstLevel : 29
				});
			}
		}
		
		Enemy.CheckMissileRange = function(_actor:Actor):Bool 
		{
			Engine.log(["I need testing!"]);
			
			var dist:Fixed;
			
			if (!Sight.CheckSight(_actor, _actor.target))
			return false;
			
			if (_actor.flags & ActorFlags.JUSTHIT > 0)
			{
				_actor.flags &= ~ActorFlags.JUSTHIT;
				return true;
			}
			
			if (_actor.reactiontime > 0) return false;
			
			dist = MapUtils.AproxDistance(_actor.xpos - _actor.target.xpos, _actor.ypos - _actor.target.ypos) - (64 * Engine.FRACUNIT);
			
			if (_actor.info.meleestate > 0) dist -= 128 * Engine.FRACUNIT;
			
			dist >> 16;
			
			if (_actor.type == DoomType.VILE) 
			{
				if (dist > 14 * 64) return false;
			}
			
			if (_actor.type == DoomType.UNDEAD) 
			{
				if (dist < 196) return false;
				dist >>= 1;
			}
			if (_actor.type == DoomType.CYBORG || _actor.type == DoomType.SPIDER || _actor.type == DoomType.SKULL)
			{
				dist >>= 1;
			}
			
			if (dist > 200) dist = 200;
			
			if (_actor.type == DoomType.CYBORG && dist > 160) dist = 160;
			
			if (Engine.GAME.p_random() < dist) return false;
			
			return true;
		}
		
	}
	
}