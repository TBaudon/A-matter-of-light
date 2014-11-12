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
	
	public static function init() {
		if(mInstance == null){
			mInstance = new Game();
			Lib.current.addChild(mInstance);
		}
		else
			throw "Game already inited.";
		
		return mInstance;
	}
	
	/*********************************
	* instance part
	**********************************/
	
	var mCurrentScreen : Screen;
	var mPaused : Bool;
	var mLastTime : Int;
	
	var mUiLayer : Sprite;
	var mGameLayer : Sprite;
	
	function new() 
	{
		super();
		mPaused = false;
		
		mUiLayer = new Sprite();
		mGameLayer = new Sprite();
		
		addChild(mGameLayer);
		addChild(mUiLayer);
		
		mLastTime = Lib.getTimer();
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
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
			mUiLayer.removeChildren();
			mGameLayer.removeChildren();
		}
		
		mCurrentScreen = screen;
		mCurrentScreen.start();
		
		mCurrentScreen.play();
	}
	
	public function getUiLayer() : Sprite {
		return mUiLayer;
	}
	
	public function getGameLayer() : Sprite {
		return mGameLayer;
	}
	
}