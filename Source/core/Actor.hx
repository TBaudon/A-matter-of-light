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
	
	var mNextPos : Vec2;
	var mNextPosBL : Vec2;
	var mNextPosTR : Vec2;
	var mNextPosBR : Vec2;
	
	var mOnFloor : Bool;
	
	var mTopCollisionSensor : Array<Vec2>;
	
	var mSpriteSheet : SpriteSheet;
	var mAnimation : Animation;
	var mCurrentFrame : Int;

	public function new(level : Level, spriteSheet : String ) 
	{
		super();
		
		mLevel = level;
		mNextPos = new Vec2();
		mNextPosBL = new Vec2();
		mNextPosTR = new Vec2();
		mNextPosBR = new Vec2();
		collidable = true;
		mSpriteSheet = new SpriteSheet(spriteSheet, 16, 16);
		mCurrentFrame = 0;
		mDim.set(10, 10);
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		dest.x -= mSpriteSheet.offsetX;
		dest.y -= mSpriteSheet.offsetY;
		buffer.copyPixels(mSpriteSheet.getBitmap(), mSpriteSheet.getFrame(mCurrentFrame), dest.toPoint());
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		vel.x += mLevel.getGravity().x * delta;
		vel.y += mLevel.getGravity().y * delta;
			
		if(mOnFloor)
			vel.x *= 0.9;
		
		mOnFloor = false;
			
		mNextPos.x = pos.x + vel.x * delta;
		mNextPos.y = pos.y + vel.y * delta;		
		
		resolveCollisionWithMap();
		
		pos.copy(mNextPos);
		
		if (mAnimation != null)
			mCurrentFrame = mAnimation.getNextFrame(delta);
		else
			mCurrentFrame = 0;
	}
	
	public function setAnimation(animation : Animation) {
		mAnimation = animation;
	}
	
	function resolveCollisionWithMap():Void 
	{
		resolveYCollision();
		resolveXCollision();	
	}

	
	function resolveYCollision():Void 
	{
		if (vel.y > 0) {
			var tileInfoBL = mLevel.getTileInfoAt(pos.x, mNextPos.y + mDim.y );
			var tileInfoBR = mLevel.getTileInfoAt(pos.x + mDim.x - 1, mNextPos.y + mDim.y);
			
			var tileAtBottomLeft = tileInfoBL != null ? tileInfoBL.block : false;
			var tileAtBottomRight = tileInfoBR != null ? tileInfoBR.block : false;
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPos.x, mNextPos.y + mDim.y);
			if (tileAtBottomLeft || tileAtBottomRight) {
				mNextPos.y = (mNextTileCoord.y) * mLevel.getTileHeight() - mDim.y;
				vel.y = 0;
				mOnFloor = true;
			}
		}else if (vel.y < 0) {
			var tileInfoTL = mLevel.getTileInfoAt(pos.x, mNextPos.y);
			var tileInfoTR = mLevel.getTileInfoAt(pos.x + mDim.x - 1, mNextPos.y);
			
			var tileAtTopLeft = tileInfoTL != null ? tileInfoTL.block : false;
			var tileAtTopRight = tileInfoTR != null ? tileInfoTR.block : false;
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPos.x, mNextPos.y);
			if (tileAtTopLeft || tileAtTopRight) {
				mNextPos.y = (mNextTileCoord.y+1) * mLevel.getTileHeight();
				vel.y = 0;
			}
		}
	}
	
	function resolveXCollision():Void 
	{
		if (vel.x > 0) {
			var tileInfoTR = mLevel.getTileInfoAt(mNextPos.x + mDim.x, pos.y);
			var tileInfoBR = mLevel.getTileInfoAt(mNextPos.x + mDim.x, pos.y + mDim.y - 1);
			
			var tileAtTopRight = tileInfoTR != null ? tileInfoTR.block : false;
			var tileAtBottomRight = tileInfoBR != null ? tileInfoBR.block : false;
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPos.x + mDim.x, mNextPos.y);
			if (tileAtTopRight || tileAtBottomRight) {
				mNextPos.x = (mNextTileCoord.x) * mLevel.getTileWidth() - mDim.x;
				vel.x = 0;
			}
		}else if (vel.x < 0) {
			var tileInfoTL = mLevel.getTileInfoAt(mNextPos.x, mNextPos.y);
			var tileInfoBL = mLevel.getTileInfoAt(mNextPos.x, mNextPos.y + mDim.y - 1);
			
			var tileAtTopLeft = tileInfoTL != null ? tileInfoTL.block : false;
			var tileAtBottomLeft = tileInfoBL != null ? tileInfoBL.block : false;
			
			var mNextTileCoord = mLevel.getTileCoordinate(mNextPos.x, mNextPos.y);
			if (tileAtTopLeft || tileAtBottomLeft ) {
				mNextPos.x = (mNextTileCoord.x+1) * mLevel.getTileWidth();
				vel.x = 0;
			}
		}
	}
}