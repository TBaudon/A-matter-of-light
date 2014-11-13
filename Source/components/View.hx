package components;
import geom.Vec2;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Thomas BAUDON
 */
class View
{
	
	public var source : BitmapData;
	public var region : Rectangle;
	
	public var origin : Vec2;
	
	public function new() 
	{
		origin = new Vec2();
	}
	
	public function getWidth() : Int {
		if (region == null && source == null)
			return 0;
		else if (region == null && source != null)
			return source.width;
		else if (region != null && source == null)
			return cast region.width;
		return cast region.width;
	}
	
	public function getHeight() : Int {
		if (region == null && source == null)
			return 0;
		else if (region == null && source != null)
			return source.height;
		else if (region != null && source == null)
			return cast region.height;
		return cast region.height;
	}
	
}