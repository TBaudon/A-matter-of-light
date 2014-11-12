package core ;
import openfl.display.Sprite;

/**
 * ...
 * @author Thomas BAUDON
 */
class Screen
{
	
	var mPaused : Bool;
	
	var mUiLayer : Sprite;
	var mGameLayer : Sprite;

	public function new() 
	{
		mPaused = false;
		
		mUiLayer = Game.getI().getUiLayer();
		mGameLayer = Game.getI().getGameLayer();
	}
	
	public function update(delta : Float) {
		
	}
	
	public function start() {
		
	}
	
	public function play() {
	}
	
	public function pause() {
		
	}
	
	public function stop() {
		
	}
	
	public function destroy() {
		
	}
	
	public function getUiLayer() : Sprite {
		return mUiLayer;
	}
	
	public function getGameLayer() : Sprite  {
		return mGameLayer;
	}
	
}