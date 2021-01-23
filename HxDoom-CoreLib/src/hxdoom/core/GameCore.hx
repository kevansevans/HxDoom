package hxdoom.core;

import hxdoom.component.Camera;
import hxdoom.component.CameraPoint;
import hxdoom.utils.math.TableRNG;

import hxdoom.Engine;
import hxdoom.enums.data.Defaults;
import hxdoom.core.action.User;

/**
 * ...
 * @author Kaelan
 */
enum EngineState {
	START_MENU;
	IN_GAME;
	IN_GAME_MENU;
	IN_GAME_PAUSE; //Pause/Break key is a different pause from pressing escape
}
class GameCore
{
	public var elapsedTime:Int;
	public var totalGameTicks:Int;
	
	public static var STATE:EngineState;
	
	public var ticrate:Int = 35;
	
	public var random:TableRNG;
	
	public function new() 
	{
		STATE = IN_GAME;
		
		random = new TableRNG(256, 1);
		
		random.shuffle(256);
	}
	
	public function start() {
		
	}
	
	public function stop() {
		
	}
	
	//This needs to be moved out!
	public function tick() {
		
		if (Engine.LEVELS.currentMap == null) return;
		
		var camera:Camera = Engine.LEVELS.currentMap.camera;
		var focus:CameraPoint = Engine.LEVELS.currentMap.focus;
		
		switch (STATE) {
			
			case IN_GAME:
				
				User.playerThink(Engine.LEVELS.currentMap.actors_players[0]);
				
				focus.x = camera.xpos + 5 * Math.cos(camera.actorToFollow.yaw.toRadians());
				focus.y = camera.ypos + 5 * Math.sin(camera.actorToFollow.yaw.toRadians());
				focus.z = camera.zpos + 5 * Math.sin(camera.actorToFollow.pitch.toRadians());
				
			case START_MENU :
				
			case IN_GAME_MENU :
				
			case IN_GAME_PAUSE :
				
			default :
				
		}
		
		++elapsedTime;
		++totalGameTicks;
	}
}