package;

import openfl.display.Sprite;
import core.Game;
import core.Level;
import core.Screen;
import screens.GameScreen;

import com.gameanalytics.GameAnalytics;
import com.gameanalytics.constants.GAErrorSeverity;

class Main extends Sprite {
	
	public function new () {
		
		super ();
		
		GameAnalytics.init(
			"aa6c6a22d1781f9d0118653600fdb97a7e9b8a27",
			"8bd543355dbb5507e17b42ddd29f8369",
			"0.0.1");
		
		var game = Game.init(3);
		addChild(game);
		game.gotoScreen(new GameScreen());
	}
	
	
}