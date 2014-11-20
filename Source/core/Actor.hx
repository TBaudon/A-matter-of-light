package core ;
import core.Level.HitDirection;
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
	
	var mNextPosTL : Vec2;
	var mNextPosBL : Vec2;
	var mNextPosTR : Vec2;
	var mNextPosBR : Vec2;
	
	var mOnFloor : Bool;
	
	var mTopCollisionSensor : Array<Vec2>;
	var mRightCollisionSensor : Array<Vec2>;
	var mBottomCollisionSensor : Array<Vec2>;
	var mLeftCollisionSensor : Array<Vec2>;

	public function new(level : Level) 
	{
		super();
		
		mLevel = level;
		mNextPosTL = new Vec2();
		mNextPosBL = new Vec2();
		mNextPosTR = new Vec2();
		mNextPosBR = new Vec2();
		collidable = true;
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
		
		vel.x += mLevel.getGravity().x * delta;
		vel.y += mLevel.getGravity().y * delta;
			
		if(mOnFloor)
			vel.x *= 0.9;
		
		mOnFloor = false;
			
		mNextPosTL.x = pos.x + vel.x * delta;
		mNextPosTL.y = pos.y + vel.y * delta;
		
		mNextPosTR.x = mNextPosTL.x + mDim.x;
		mNextPosTR.y = mNextPosTL.y;
		
		mNextPosBL.x = mNextPosTL.x;
		mNextPosBL.y = mNextPosTL.y + mDim.y;
		
		mNextPosBR.x = mNextPosTR.x;
		mNextPosBR.y = mNextPosBL.y;
		
		
		resolveCollisionWithMap();
		
		pos.copy(mNextPosTL);
	}
	
	function resolveCollisionWithMap():Void 
	{
		resolveYCollision();
		resolveXCollision();	
	}

	
	function resolveYCollision():Void 
	{
		if (vel.y > 0) {
			var tileInfoBL = mLevel.getTileInfoAt(pos.x, mNextPosTL.y + mDim.y );
			var tileInfoBR = mLevel.getTileInfoAt(pos.x + mDim.x - 1, mNextPosTL.y + mDim.y);
			
			var tileAtBottomLeft = tileInfoBL != null ? tileInfoBL.block : false;
			var tileAtBottomRight = tileInfoBR != null ? tileInfoBR.block : false;
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPosTL.x, mNextPosTL.y + mDim.y);
			if (tileAtBottomLeft || tileAtBottomRight) {
				mNextPosTL.y = (mNextTileCoord.y) * mLevel.getTileHeight() - mDim.y;
				vel.y = 0;
				mOnFloor = true;
			}
		}else if (vel.y < 0) {
			var tileInfoTL = mLevel.getTileInfoAt(pos.x, mNextPosTL.y);
			var tileInfoTR = mLevel.getTileInfoAt(pos.x + mDim.x - 1, mNextPosTL.y);
			
			var tileAtTopLeft = tileInfoTL != null ? tileInfoTL.block : false;
			var tileAtTopRight = tileInfoTR != null ? tileInfoTR.block : false;
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPosTL.x, mNextPosTL.y);
			if (tileAtTopLeft || tileAtTopRight) {
				mNextPosTL.y = (mNextTileCoord.y+1) * mLevel.getTileHeight();
				vel.y = 0;
			}
		}
	}
	
	function resolveXCollision():Void 
	{
		if (vel.x > 0) {
			var tileInfoTR = mLevel.getTileInfoAt(mNextPosTL.x + mDim.x, pos.y);
			var tileInfoBR = mLevel.getTileInfoAt(mNextPosTL.x + mDim.x, pos.y + mDim.y - 1);
			
			var tileAtTopRight = tileInfoTR != null ? tileInfoTR.block : false;
			var tileAtBottomRight = tileInfoBR != null ? tileInfoBR.block : false;
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPosTL.x + mDim.x, mNextPosTL.y);
			if (tileAtTopRight || tileAtBottomRight) {
				mNextPosTL.x = (mNextTileCoord.x) * mLevel.getTileWidth() - mDim.x;
				vel.x = 0;
			}
		}else if (vel.x < 0) {
			var tileInfoTL = mLevel.getTileInfoAt(mNextPosTL.x, mNextPosTL.y);
			var tileInfoBL = mLevel.getTileInfoAt(mNextPosTL.x, mNextPosTL.y + mDim.y - 1);
			
			var tileAtTopLeft = tileInfoTL != null ? tileInfoTL.block : false;
			var tileAtBottomLeft = tileInfoBL != null ? tileInfoBL.block : false;
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPosTL.x, mNextPosTL.y);
			if (tileAtTopLeft || tileAtBottomLeft ) {
				mNextPosTL.x = (mNextTileCoord.x+1) * mLevel.getTileWidth();
				vel.x = 0;
			}
		}
	}
}