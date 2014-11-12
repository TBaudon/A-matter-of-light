package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import screens.Screen;

/**
 * ...
 * @author Thomas BAUDON
 */
class Game extends Sprite
{
	/*********************************
	* static part
	**********************************/
	
	static var mInstance : Game;

	public static function getI() : Game {
		if (mInstance == null)
			throw "Game must be inited.";
		return mInstance;
	}
	
	public static function init(firstScreen : Screen) {
		if(mInstance == null)
			mInstance = new Game(firstScreen);
		else
			throw "Game already inited.";
	}
	
	/*********************************
	* instance part
	**********************************/
	
	var mFirstScreen : Screen;
	var mCurrentScreen : Screen;
	var mPaused : Bool;
	
	function new(firstScreen : Screen) 
	{
		super();
		mFirstScreen = firstScreen;
		mPaused = false;
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update(e:Event):Void 
	{
		if (mCurrentScreen != null)
			mCurrentScreen.update();
	}
	
	public function togglePause() {
		mPaused = !mPaused;
	}
	
	public function gotoScreen(screen : Screen) {
		if (mCurrentScreen != null){
			mCurrentScreen.stop();
			mCurrentScreen.destroy();
		}
		
		mCurrentScreen = screen;
		
		mCurrentScreen.play();
	}
	
}