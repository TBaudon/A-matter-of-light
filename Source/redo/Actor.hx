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
	
	var mOnFloor : Bool;

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
		
		mOnFloor = false;
		
		vel.x += mLevel.getGravity().x;
		vel.y += mLevel.getGravity().y;
		
		mNextPos.x = pos.x + vel.x * delta;
		mNextPos.y = pos.y + vel.y * delta;
		
		resolveCollisionWithMap();
		
		
		
		
		pos.copy(mNextPos);
	}
	
	function resolveCollisionWithMap():Void 
	{
		if(vel.x > vel.y){
			resolveXCollision();
			resolveYCollision();
		}else {
			resolveYCollision();
			resolveXCollision();
		}
	}
	
	function resolveYCollision():Void 
	{
		if (vel.y > 0) {
			var tileAtBottomLeft = mLevel.getTileAt(mNextPos.x + 1, mNextPos.y + dim.y );
			var tileAtBottomRight = mLevel.getTileAt(mNextPos.x + dim.x - 1, mNextPos.y + dim.y);
			
			if (tileAtBottomLeft != 0 || tileAtBottomRight != 0) {
				mNextPos.y = Std.int((mNextPos.y + dim.y) / mLevel.getTileHeight()) * mLevel.getTileHeight() - dim.y;
				vel.y = 0;
				mOnFloor = true;
			}
		}else if (vel.y < 0) {
			var tileAtTopLeft = mLevel.getTileAt(mNextPos.x + 1, mNextPos.y);
			var tileAtTopRight = mLevel.getTileAt(mNextPos.x + dim.x - 1, mNextPos.y);
			
			if (tileAtTopLeft != 0 || tileAtTopRight != 0) {
				mNextPos.y = Std.int(mNextPos.y / mLevel.getTileHeight()) * mLevel.getTileHeight() + mLevel.getTileHeight();
				vel.y = 0;
			}
		}
	}
	
	function resolveXCollision():Void 
	{
		if (vel.x > 0) {
			var tileAtTopRight = mLevel.getTileAt(mNextPos.x + dim.x , mNextPos.y + 1);
			var tileAtBottomRight = mLevel.getTileAt(mNextPos.x + dim.x , mNextPos.y + dim.y - 1);
			
			if (tileAtTopRight != 0 || tileAtBottomRight != 0) {
				mNextPos.x = Std.int((mNextPos.x + dim.x) / mLevel.getTileWidth()) * mLevel.getTileWidth() - dim.x;
				vel.x = 0;
			}
		}else if (vel.x < 0) {
			var tileAtTopLeft = mLevel.getTileAt(mNextPos.x , mNextPos.y + 1);
			var tileAtBottomLeft = mLevel.getTileAt(mNextPos.x , mNextPos.y + dim.y - 1);
			
			if (tileAtTopLeft != 0 || tileAtBottomLeft != 0) {
				mNextPos.x = Std.int(mNextPos.x / mLevel.getTileWidth()) * mLevel.getTileWidth() + mLevel.getTileWidth();
				vel.x = 0;
			}
		}
	}
}