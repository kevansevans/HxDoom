package hxdoom.core;

import haxe.Timer;

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
		switch (STATE) {
			
			case IN_GAME:
				if (Environment.PLAYER_MOVING_FORWARD) {
					Engine.ACTIVEMAP.actors_players[0].move(8);
				}
				if (Environment.PLAYER_MOVING_BACKWARD) {
					Engine.ACTIVEMAP.actors_players[0].move(-8);
				}
				if (Environment.PLAYER_TURNING_LEFT) {
					Engine.ACTIVEMAP.actors_players[0].angle += 2;
				}
				if (Environment.PLAYER_TURNING_RIGHT) {
					Engine.ACTIVEMAP.actors_players[0].angle -= 2;
				}
				
			case START_MENU :
				
			case IN_GAME_MENU :
				
			case IN_GAME_PAUSE :
				
			default :
				
		}
	}
}