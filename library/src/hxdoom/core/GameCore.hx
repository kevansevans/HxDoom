package hxdoom.core;

import hxdoom.utils.extensions.Camera;
import hxdoom.utils.extensions.CameraPoint;

import hxdoom.Engine;
import hxdoom.enums.data.Defaults;

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
	public static var STATE:EngineState;
	
	public var ticrate:Int = 35;
	
	public function new() 
	{
		STATE = IN_GAME;
	}
	
	public function start() {
		
	}
	
	public function stop() {
		
	}
	
	//This needs to be moved out!
	public function tick() {
		
		var camera:Camera = Engine.ACTIVEMAP.camera;
		var focus:CameraPoint = Engine.ACTIVEMAP.focus;
		
		switch (STATE) {
			
			case IN_GAME:
				if (CVarCore.getCvar(Defaults.PLAYER_MOVING_FORWARD)) {
					Engine.ACTIVEMAP.actors_players[0].move(8);
				}
				if (CVarCore.getCvar(Defaults.PLAYER_MOVING_BACKWARD)) {
					Engine.ACTIVEMAP.actors_players[0].move(-8);
				}
				if (CVarCore.getCvar(Defaults.PLAYER_TURNING_LEFT)) {
					Engine.ACTIVEMAP.actors_players[0].yaw += 2;
				}
				if (CVarCore.getCvar(Defaults.PLAYER_TURNING_RIGHT)) {
					Engine.ACTIVEMAP.actors_players[0].yaw -= 2;
				}
				
				focus.x = camera.xpos + 5 * Math.cos(camera.actorToFollow.yaw.toRadians());
				focus.y = camera.ypos + 5 * Math.sin(camera.actorToFollow.yaw.toRadians());
				focus.z = camera.zpos + 5 * Math.sin(camera.actorToFollow.pitch.toRadians());
				
			case START_MENU :
				
			case IN_GAME_MENU :
				
			case IN_GAME_PAUSE :
				
			default :
				
		}
	}
}