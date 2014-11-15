package entities ;
import ash.core.Entity;
import components.Body;
import components.Camera;
import components.PlayerControler;
import components.Transform;
import components.View;
import openfl.display.BitmapData;
import openfl.display.Sprite;

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
		add(new Camera());
		var view = new View();
		view.source = new BitmapData(16, 16, false, 0xff0000);
		view.origin.x = 0.5;
		view.origin.y = 1.0;
		add(view);
		add(new PlayerControler());
		
		var body = new Body(BodyType.DYNAMIC, 16, 16);
		body.origin.x = 0.5;
		body.origin.y = 1.0;
		add(body);
		
	}
	
}