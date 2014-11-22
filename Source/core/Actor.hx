package core ;
import core.Level.HitDirection;
import entities.Laser;
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
	var mFloorFriction : Float;
	var mAirFriction : Float;
	
	var mSolid : Bool;
	var mStatic : Bool;
	
	var mTimeMutiplier : Float;
	var mSlowDownTimeCounter : Float;
	
	public static var AllActors : Array<Actor>;

	public function new(spriteSheet : String = null) 
	{
		super();
		
		if (AllActors == null)
			AllActors = new Array<Actor>();
		AllActors.push(this);
		
		mNextPos = new Vec2();
		mNextPosBL = new Vec2();
		mNextPosTR = new Vec2();
		mNextPosBR = new Vec2();
		collidable = true;
		if(spriteSheet != null)
			mSpriteSheet = new SpriteSheet(spriteSheet, 16, 16);
		mCurrentFrame = 0;
		mDim.set(10, 10);
		mFloorFriction = 0.75;
		mAirFriction = 0.9;
		mTimeMutiplier = 1;
	}
	
	public function setLevel(level : Level) {
		mLevel = level;
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		if(mSpriteSheet != null){
			dest.x -= mSpriteSheet.offsetX;
			dest.y -= mSpriteSheet.offsetY;
			buffer.copyPixels(mSpriteSheet.getBitmap(), mSpriteSheet.getFrame(mCurrentFrame), dest.toPoint());
		}
	}
	
	public function setProperties(props : Dynamic) {
		
	}
	
	override function update(delta:Float) 
	{
		delta *= mTimeMutiplier;
		super.update(delta);
		if(!mStatic){
			vel.x += mLevel.getGravity().x * delta;
			vel.y += mLevel.getGravity().y * delta;
			
			if(mOnFloor)
				vel.x *= mFloorFriction;
			else
				vel.x *= mAirFriction;
			
			mOnFloor = false;
		}
				
			mNextPos.x = pos.x + vel.x * delta;
			mNextPos.y = pos.y + vel.y * delta;		
		
		if(!mStatic)
			resolveCollisionWithMap();
			
		resolveCollisionWithOthers();
		
		if(!mStatic)
			pos.copy(mNextPos);
		
		if (mAnimation != null)
			mCurrentFrame = mAnimation.getNextFrame(delta);
		else
			mCurrentFrame = 0;
			
		if(mTimeMutiplier < 1){
			mSlowDownTimeCounter += delta / mTimeMutiplier;
			if (mSlowDownTimeCounter >= 5)
				mTimeMutiplier = 1;
		}
	}
	
	function resolveCollisionWithOthers() 
	{
		for (actor in AllActors) {
			if (actor != this) {
				if (mNextPos.x < actor.pos.x + actor.getDim().x &&
					mNextPos.x + mDim.x > actor.pos.x &&
					mNextPos.y < actor.pos.y + actor.getDim().y &&
					mNextPos.y + mDim.y > actor.pos.y) {
						onCollideOther(actor);
					}
			}
		}
	}
	
	public function onCollideOther(actor : Actor) {
		if (mStatic) return;
		if (mSolid && actor.isSolid())
		{
			var diffX = (actor.pos.x + actor.getDim().x / 2) - (pos.x + mDim.x / 2);
			var diffY = (actor.pos.y + actor.getDim().y / 2) - (pos.y + mDim.y / 2);
			var dist = Math.sqrt(diffX * diffX + diffY * diffY);
			actor.vel.x -= diffX;
			actor.vel.y -= diffY;
		}
		
	}
	
	public function setAnimation(animation : Animation) {
		mAnimation = animation;
	}
	
	public function isStatic() : Bool {
		return mStatic;
	}
	
	public function isSolid() : Bool {
		return mSolid;
	}
	
	function resolveCollisionWithMap():Void 
	{
		resolveYCollision();
		resolveXCollision();	
	}
	
	override public function destroy() 
	{
		super.destroy();
		AllActors.remove(this);
	}
	
	public function onLaserHit(laser : Laser, delta : Float) {
		if (laser.getLastColor() == 0xff0000) {
			vel.add(Vec2.Mul(laser.getDir(), 0.1 * delta));
		}else if (laser.getLastColor() == 0x0000ff) {
			slowDown(0.2,delta);
		}
	}
	
	function slowDown(coef : Float, time : Float) {
		mSlowDownTimeCounter = 0;
		mTimeMutiplier = coef;
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