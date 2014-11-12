package levels;

import ash.core.Entity;
import components.Transform;
import components.View;
import core.Level;
import entities.hero.Hero;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.shape.Shape;
import systems.PhysicSystem;
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
		
		addSystem(new PhysicSystem());
		addSystem(new RenderSystem());
		
		add(new Hero());
	}
	
}