package components;
import nape.geom.Vec2;

/**
 * ...
 * @author Thomas BAUDON
 */
class Transform
{
	
	public var rotation : Float = 0;
	public var position : Vec2;
	public var pivot : Vec2;
	public var scale : Vec2;

	public function new() 
	{
		position = Vec2.get(0, 0);
		scale = Vec2.get(1.0, 1.0);
		pivot = Vec2.get(0.5, 0.5);
	}
	
}