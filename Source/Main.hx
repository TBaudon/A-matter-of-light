package;

import openfl.display.Sprite;
import core.Game;
import core.Level;
import core.Screen;

class Main extends Sprite {
	
	public function new () {
		
		super ();
		
		var game = Game.init(2);
		var level = new Level("testMap");
		level.load();
		
		var screen = new Screen();
		screen.add(level);
		
		game.gotoScreen(screen);
		
		
	}
	
	
}