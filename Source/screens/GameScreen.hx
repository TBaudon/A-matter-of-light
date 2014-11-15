package screens;
import ash.core.Engine;
import core.Level;
import core.Screen;
import systems.PhysicSystem;
import systems.PlayerControlSystem;
import systems.RenderSystem;
import systems.TileMapSystem;

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
		
		var level = new Level();
		level.load(levelName);
		
		if (mCurrentLevel != null) {
			// unload current level
			mEngine.removeAllEntities();
			mEngine.removeAllSystems();
		}
		
		mCurrentLevel = level;
		
		// add sysytems
		mEngine.addSystem(new PlayerControlSystem(),0);
		mEngine.addSystem(new PhysicSystem(),10);
		mEngine.addSystem(new TileMapSystem(),20);
		mEngine.addSystem(new RenderSystem(),30);
		
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