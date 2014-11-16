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
	
	var mTopCollisionSensor : Array<Vec2>;
	var mRightCollisionSensor : Array<Vec2>;
	var mBottomCollisionSensor : Array<Vec2>;
	var mLeftCollisionSensor : Array<Vec2>;

	public function new(level : Level) 
	{
		super();
		
		mLevel = level;
		mNextPos = new Vec2();
		
		mDim.set(10, 10);
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		buffer.fillRect(new Rectangle(Std.int(dest.x), Std.int(dest.y), mDim.x, mDim.y), 0x0000cc);
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		if(!mOnFloor){
			vel.x += mLevel.getGravity().x;
			vel.y += mLevel.getGravity().y;
		}
		
		mNextPos.x = pos.x + vel.x * delta;
		mNextPos.y = pos.y + vel.y * delta;
		
		resolveCollisionWithMap();
		checkFloor();
		
		pos.copy(mNextPos);
	}
	
	function checkFloor() 
	{
		if (mLevel.getTileAt(pos.x, pos.y + mDim.y) == 0 ||
			mLevel.getTileAt(pos.x + mDim.x - 1, pos.y + mDim.y) == 0)
			mOnFloor = false;
	}
	
	function resolveCollisionWithMap():Void 
	{
		resolveYCollision();
		resolveXCollision();
	}
	
	function resolveYCollision():Void 
	{
		if (vel.y > 0) {
			var tileAtBottomLeft = mLevel.getTileAt(pos.x, mNextPos.y + mDim.y-1 );
			var tileAtBottomRight = mLevel.getTileAt(pos.x + mDim.x-1, mNextPos.y + mDim.y-1);
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPos.x, mNextPos.y + mDim.y-1);
			if (tileAtBottomLeft != 0 || tileAtBottomRight != 0) {
				mNextPos.y = (mNextTileCoord.y) * mLevel.getTileHeight() - mDim.y;
				vel.y = 0;
				mOnFloor = true;
			}
		}else if (vel.y < 0) {
			var tileAtTopLeft = mLevel.getTileAt(pos.x, mNextPos.y);
			var tileAtTopRight = mLevel.getTileAt(pos.x + mDim.x - 1, mNextPos.y);
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPos.x, mNextPos.y);
			if (tileAtTopLeft != 0 || tileAtTopRight != 0) {
				mNextPos.y = (mNextTileCoord.y+1) * mLevel.getTileHeight();
				vel.y = 0;
			}
		}
	}
	
	function resolveXCollision():Void 
	{
		if (vel.x > 0) {
			var tileAtTopRight = mLevel.getTileAt(mNextPos.x + mDim.x-1, pos.y);
			var tileAtBottomRight = mLevel.getTileAt(mNextPos.x + mDim.x-1, pos.y + mDim.y-1);
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPos.x + mDim.x-1, mNextPos.y);
			if (tileAtTopRight != 0 || tileAtBottomRight != 0) {
				mNextPos.x = (mNextTileCoord.x) * mLevel.getTileWidth() - mDim.x;
				vel.x = 0;
			}
		}else if (vel.x < 0) {
			var tileAtTopLeft = mLevel.getTileAt(mNextPos.x, mNextPos.y);
			var tileAtBottomLeft = mLevel.getTileAt(mNextPos.x, mNextPos.y + mDim.y - 1);
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPos.x, mNextPos.y);
			if (tileAtTopLeft != 0 || tileAtBottomLeft != 0) {
				mNextPos.x = (mNextTileCoord.x+1) * mLevel.getTileWidth();
				vel.x = 0;
			}
		}
	}
}