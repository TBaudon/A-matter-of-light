package levels;

import ash.core.Entity;
import components.TileMap;
import components.Transform;
import components.View;
import core.Level;
import entities.hero.Hero;
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
		
		
		var tileMap = new TileMap(20, 20, 16);
		tileMap.tileSet = Assets.getBitmapData("img/testTileSet.png");
		tileMap.map[3][3] = 2;
		
		var map = new Entity("map");
		map.add(tileMap);
		map.add(new View());
		map.add(new Transform());
		
		add(map);
		add(new Hero());
	}
	
}