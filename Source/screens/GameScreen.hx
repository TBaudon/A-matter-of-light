package screens;
import core.Actor;
import core.Entity;
import core.Level;
import core.Screen;
import entities.Hero;

/**
 * ...
 * @author Thomas B
 */
class GameScreen extends Screen
{
	
	var mActorToKeep : Map<String, Actor>;
	var mCurrentLevel : Level;

	public function new() 
	{
		super();
		
		mActorToKeep = new Map<String, Actor>();
		//mActorToKeep.set("Hero", new Hero());
		
		//loadLevel("level1");
		loadLevel("level3");
		//loadLevel("test3");
	}
	
	public function loadLevel(name : String) {
		if (mCurrentLevel != null)
			mCurrentLevel.destroy();
		mCurrentLevel = new Level(this, name, mActorToKeep);
		mCurrentLevel.load();
		add(mCurrentLevel);
	}
	
}