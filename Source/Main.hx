package;


import openfl.display.Sprite;
import screens.MenuScreen;

import core.Game;

class Main extends Sprite {
	
	public function new () {
		
		super ();
		
		var game = Game.init();
		game.gotoScreen(new MenuScreen());
	}
	
	
}