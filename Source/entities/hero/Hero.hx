package entities.hero ;
import ash.core.Entity;
import components.PlayerControler;
import components.Transform;
import components.View;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

/**
 * ...
 * @author Thomas BAUDON
 */
class Hero extends Entity
{

	public function new() 
	{
		super("Hero");
		
		add(new Transform());
		add(new HeroView(), View);
		add(new PlayerControler());
		
		var body = new Body(BodyType.DYNAMIC);
		body.shapes.add(new Polygon(Polygon.rect( -20, -100, 40, 100)));
		add(body);
		
	}
	
}