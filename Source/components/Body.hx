package components ;
import components.Body.BodyType;
import geom.Vec2;

/**
 * ...
 * @author Thomas BAUDON
 */

enum BodyType {
	STATIC;
	DYNAMIC;
	KINEMATIC;
}
 
class Body
{
	
	public var w : Float;
	public var h : Float;
	
	public var position : Vec2;
	public var velocity : Vec2;
	public var origin : Vec2;
	
	public var type : BodyType;

	public function new(type : BodyType, w : Float, h : Float) 
	{
		this.w = w;
		this.h = h;
		this.type = type;
		
		position = new Vec2();
		velocity = new Vec2();
		origin = new Vec2(0.5, 0.5);
	}
	
	public function applyForce(force : Vec2) {
		velocity.add(force);
	}
	
	
}