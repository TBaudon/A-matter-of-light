package levels;

import ash.core.Entity;
import components.Transform;
import components.View;
import core.Level;
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
		
		var testEnt = new Entity("test");
		testEnt.add(new View());
		testEnt.add(new Transform());
		
		var body = new Body(BodyType.DYNAMIC);
		body.shapes.add(new Polygon(Polygon.rect(0, 0, 20, 20)));
		testEnt.add(body);
		
		add(testEnt);
	}
	
}