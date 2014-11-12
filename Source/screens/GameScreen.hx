package screens;
import ash.core.Engine;
import core.Screen;

/**
 * ...
 * @author Thomas BAUDON
 */
class GameScreen extends Screen
{
	
	var mEngine : Engine;

	public function new() 
	{
		super();
		
		mEngine = new Engine();
	}
	
	override public function update(delta : Float) {
		if(!mPaused)
			mEngine.update(delta);
	}
	
}