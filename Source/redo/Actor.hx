package redo;
import geom.Vec2;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Thomas BAUDON
 */
class Actor extends Entity
{
	
	var mLevel : Level;
	var mNextPos : Vec2;

	public function new(level : Level) 
	{
		super();
		
		mLevel = level;
		mNextPos = new Vec2();
		dim.x = 16;
		dim.y = 16;
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		buffer.fillRect(new Rectangle(Std.int(dest.x), Std.int(dest.y), dim.x, dim.y), 0x0000cc);
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		vel.x += mLevel.getGravity().x;
		vel.y += mLevel.getGravity().y;
		
		mNextPos.x = pos.x + vel.x * delta;
		mNextPos.y = pos.y + vel.y * delta;
		
		var tileToTestOnX = Math.ceil(dim.x / mLevel.getTileWidth());
		if (vel.y > 0) {
			var tileAtBottomLeft = mLevel.getTileAt(mNextPos.x, mNextPos.y + dim.y);
			var tileAtBottomRight = mLevel.getTileAt(mNextPos.x + dim.x, mNextPos.y + dim.y);
			
			if (tileAtBottomLeft != 0 || tileAtBottomRight != 0) {
				mNextPos.y = Std.int((mNextPos.y + dim.y) / mLevel.getTileHeight()) * mLevel.getTileHeight() - dim.y;
				vel.y = 0;
			}
		}else if (vel.y < 0) {
			
		}
		
		
		
		
		pos.copy(mNextPos);
	}
}