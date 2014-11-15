package;

import openfl.display.Sprite;
import redo.Game;
import redo.Level;
import redo.Screen;

class Main extends Sprite {
	
	public function new () {
		
		super ();
		
		var game = Game.init();
		var level = new Level("testMap");
		level.load();
		
		var screen = new Screen();
		screen.add(level);
		
		game.gotoScreen(screen);
	}
	
	
}