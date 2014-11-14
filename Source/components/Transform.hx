package components;
import geom.Vec2;

/**
 * ...
 * @author Thomas BAUDON
 */
class Transform
{
	
	public var rotation : Float = 0;
	public var position : Vec2;
	public var scale : Vec2;
	public var offset : Vec2;

	public function new() 
	{
		position = new Vec2();
		offset = new Vec2();
		scale = new Vec2(1.0, 1.0);
	}
	
}