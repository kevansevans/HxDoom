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
		timer = new Timer(Std.int(1000 / ticrate));
		STATE = IN_GAME;
	}
	
	public function start() {
		timer.run = tick;
	}
	
	public function stop() {
		timer.stop();
	}
	
	public function tick() {
		
		switch (STATE) {
			
			case IN_GAME:
				if (Environment.PLAYER_MOVING_FORWARD) {
					Engine.ACTIVEMAP.actors_players[0].move(5);
				}
				if (Environment.PLAYER_MOVING_BACKWARD) {
					Engine.ACTIVEMAP.actors_players[0].move(-5);
				}
				if (Environment.PLAYER_TURNING_LEFT) {
					Engine.ACTIVEMAP.actors_players[0].angle += 1;
				}
				if (Environment.PLAYER_TURNING_RIGHT) {
					Engine.ACTIVEMAP.actors_players[0].angle -= 1;
				}
				
			case START_MENU :
				
			case IN_GAME_MENU :
				
			case IN_GAME_PAUSE :
				
			default :
				
		}
	}
}