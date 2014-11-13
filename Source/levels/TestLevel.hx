package levels;

import ash.core.Entity;
import components.Transform;
import components.View;
import core.Level;
import entities.hero.Hero;
import entities.Platform;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.shape.Shape;
import systems.PhysicSystem;
import systems.PlayerControlSystem;
import systems.RenderSystem;

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
		addSystem(new RenderSystem());
		
		add(new Hero());
		add(new Platform(0, 550, 800, 50));
		add(new Platform(300, 300, 300, 50));
	}
	
}