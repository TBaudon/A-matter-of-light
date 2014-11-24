package;

import openfl.display.Sprite;
import core.Game;
import core.Level;
import core.Screen;
import screens.GameScreen;

class Main extends Sprite {
	
	public function new () {
		
		super ();
		
		var game = Game.init(3);
		addChild(game);
		game.gotoScreen(new GameScreen());
	}
	
	
}