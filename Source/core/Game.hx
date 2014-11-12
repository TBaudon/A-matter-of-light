package core ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import core.Screen;

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
		if(mInstance == null){
			mInstance = new Game(firstScreen);
			Lib.current.addChild(mInstance);
		}
		else
			throw "Game already inited.";
	}
	
	/*********************************
	* instance part
	**********************************/
	
	var mFirstScreen : Screen;
	var mCurrentScreen : Screen;
	var mPaused : Bool;
	var mLastTime : Int;
	
	function new(firstScreen : Screen) 
	{
		super();
		mFirstScreen = firstScreen;
		mPaused = false;
		
		mLastTime = Lib.getTimer();
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
		
		gotoScreen(mFirstScreen);
	}
	
	function update(e:Event):Void 
	{
		var time = Lib.getTimer();
		var delta = time - mLastTime;
		mLastTime = time;
		
		if (mCurrentScreen != null)
			mCurrentScreen.update(delta * 0.001);
	}
	
	public function togglePause() {
		mPaused = !mPaused;
		if (mPaused)
			mCurrentScreen.pause();
		else
			mCurrentScreen.play();
	}
	
	public function gotoScreen(screen : Screen) {
		if (mCurrentScreen != null){
			mCurrentScreen.stop();
			mCurrentScreen.destroy();
			removeChild(mCurrentScreen);
		}
		
		mCurrentScreen = screen;
		addChild(mCurrentScreen);
		
		mCurrentScreen.play();
	}
	
}