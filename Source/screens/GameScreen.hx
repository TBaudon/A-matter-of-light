package screens;
import ash.core.Engine;
import core.Level;
import core.Screen;

/**
 * ...
 * @author Thomas BAUDON
 */
class GameScreen extends Screen
{
	var mEngine : Engine;
	var mCurrentLevel : Level;
	var mLevel:String;

	public function new(level : String) 
	{
		super();
		
		mEngine = new Engine();
		mLevel = level;
	}
	
	override public function start() {
		loadLevel(mLevel);
	}
	
	function loadLevel(levelName : String) {
		
		var levelClass : Class<Dynamic> = Type.resolveClass("levels." + levelName);
		var level = Type.createInstance(levelClass, []);
		
		if (mCurrentLevel != null) {
			// unload current level
			mEngine.removeAllEntities();
			mEngine.removeAllSystems();
		}
		
		mCurrentLevel = level;
		
		// load level's system
		var systems = mCurrentLevel.getSystems();
		
		for (sys in systems)
			mEngine.addSystem(sys,0);
		
		// load level's entities
		var entities = mCurrentLevel.getEntities();
		
		for (ent in entities)
			mEngine.addEntity(ent);
	}
	
	override public function update(delta : Float) {
		if(!mPaused)
			mEngine.update(delta);
	}
	
}