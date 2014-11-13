package geom;

/**
 * ...
 * @author Thomas BAUDON
 */
class Vec2
{
	
	public var x : Float;
	public var y : Float;

	public function new(x:Float = 0, y : Float = 0) 
	{
		this.x = x;
		this.y = y;
	}
	
	public function add(v : Vec2) : Vec2 {
		x += v.x;
		y += v.y;
		return this;
	}
	
	public static function Add(a : Vec2, b : Vec2) : Vec2 {
		return new Vec2(a.x + b.x, a.y + b.y);
	}
	
	public function sub(v : Vec2) : Vec2 {
		x -= v.x;
		y -= v.y;
		return this;
	}
	
	public static function Sub(a : Vec2, b : Vec2) : Vec2 {
		return new Vec2(a.x - b.x, a.y - b.y);
	}
	
	public function mul(f : Float) : Vec2 {
		x *= f;
		y *= f;
		return this;
	}
	
	public static function Mul(a : Vec2, f : Float) : Vec2 {
		return new Vec2(a.x * f, a.y * f);
	}
	
	public function length() : Float {
		return Math.sqrt(x * x + y * y);
	}
	
}