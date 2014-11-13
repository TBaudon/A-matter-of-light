package entities;
import ash.core.Entity;
import components.Transform;
import components.View;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

/**
 * ...
 * @author Thomas BAUDON
 */
class Platform extends Entity
{

	public function new(x : Float, y :Float, width:Float, height : Float) 
	{
		super();
		
		var view = new View();
		view.graphics.lineStyle(2, 0);
		view.graphics.beginFill(0xcccccc);
		view.graphics.drawRect(0, 0, width, height);
		view.graphics.endFill();
		add(view);
		
		add(new Transform());
		
		var body = new Body(BodyType.STATIC);
		body.shapes.add(new Polygon(Polygon.rect(0, 0, width, height)));
		body.position.x = x;
		body.position.y = y;
		
		add(body);
	}
	
}