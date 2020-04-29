package hxdoom.core;

import cpp.Callable;
import haxe.Timer;
import hxdoom.utils.Camera;
import hxdoom.utils.CameraPoint;

import hxdoom.Engine;
import hxdoom.common.Environment;

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
	
	var timer:Timer;
	
	public function new() 
	{
		STATE = IN_GAME;
	}
	
	public function start() {
		timer = new Timer(Std.int(1000 / ticrate));
		timer.run = tick;
	}
	
	public function stop() {
		if (timer != null) timer.stop();
	}
	
	public function tick() {
		
		var camera:Camera = Engine.ACTIVEMAP.camera;
		var focus:CameraPoint = Engine.ACTIVEMAP.focus;
		
		switch (STATE) {
			
			case IN_GAME:
				if (CVarCore.getCvar(EnvName.PLAYER_MOVING_FORWARD)) {
					Engine.ACTIVEMAP.actors_players[0].move(8);
				}
				if (CVarCore.getCvar(EnvName.PLAYER_MOVING_BACKWARD)) {
					Engine.ACTIVEMAP.actors_players[0].move(-8);
				}
				if (CVarCore.getCvar(EnvName.PLAYER_TURNING_LEFT)) {
					Engine.ACTIVEMAP.actors_players[0].yaw += 2;
				}
				if (CVarCore.getCvar(EnvName.PLAYER_TURNING_RIGHT)) {
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