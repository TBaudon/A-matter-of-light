package components;
import openfl.display.Sprite;

/**
 * ...
 * @author Thomas BAUDON
 */
class View extends Sprite
{

	public function new() 
	{
		super();
		
		graphics.beginFill(0xff0000);
		graphics.drawRect(0, 0, 20, 20);
	}
	
}