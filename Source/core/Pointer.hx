package core ;
import geom.Vec2;
import openfl.display.BitmapData;

/**
 * ...
 * @author Thomas BAUDON
 */
class Pointer extends Entity
{

	public function new() 
	{
		super();
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		buffer.setPixel(cast pos.x, cast pos.y, 0);
	}
	
}