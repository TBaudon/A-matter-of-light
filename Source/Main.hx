package;


import openfl.display.Sprite;
import screens.MenuScreen;


class Main extends Sprite {
	
	public function new () {
		
		super ();
		
		Game.init(new MenuScreen());
	}
	
	
}