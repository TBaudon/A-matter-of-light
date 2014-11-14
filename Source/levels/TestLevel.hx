package levels;

import ash.core.Entity;
import components.TileMap;
import components.Transform;
import components.View;
import core.Level;
import entities.Hero;
import openfl.Assets;
import openfl.display.BitmapData;
import systems.PhysicSystem;
import systems.PlayerControlSystem;
import systems.RenderSystem;
import systems.TileMapSystem;

/**
 * ...
 * @author Thomas BAUDON
 */
class TestLevel extends Level
{

	public function new() 
	{
		super();
		
		addSystem(new PlayerControlSystem());
		addSystem(new PhysicSystem());
		addSystem(new TileMapSystem());
		addSystem(new RenderSystem());
		
		load("testMap");
		//add(new Hero());
	}
	
}