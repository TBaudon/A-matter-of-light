package entities ;
import core.Actor;
import core.Animation;
import entities.Laser;
import core.Level;
import geom.Vec2;
import openfl.display.BitmapData;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Thomas BAUDON
 */
class Hero extends Actor
{
	
	var mJumpDown : Bool;
	var mXAxis : Float;
	var mFiring : Bool;
	var mLaser : Laser;
	
	var mInventory : Array<UInt>;
	var mEquipedItem : UInt;
	var mChangedWeapon : Bool;
	
	var mStandAnimR : Animation;
	var mWalkAnimR : Animation;
	var mStandAnimL : Animation;
	var mWalkAnimL : Animation;
	var mJumpAnimR : Animation;
	var mJumpAnimL : Animation;
	var mFallAnimR : Animation;
	var mFallAnimL : Animation;
	
	var mStandAnimRFiring : Animation;
	var mWalkAnimRFiring : Animation;
	var mStandAnimLFiring : Animation;
	var mWalkAnimLFiring : Animation;
	var mJumpAnimRFiring : Animation;
	var mJumpAnimLFiring : Animation;
	var mFallAnimRFiring : Animation;
	var mFallAnimLFiring : Animation;
	
	inline static var WALK_STRENGTH : Int = 1000;
	
	var mLookingDir : Int;
	
	static private inline var JUMP_STRENGHT:Float = 430;

	public function new(level : Level) 
	{
		super(level, "hero");
		mSpriteSheet.offsetX = 5;
		mSpriteSheet.offsetY = 4;
		setDim(6, 12);
		mXAxis = 0;
		
		mLookingDir = 1;
		
		mInventory = new Array<UInt>();
		
		mInventory.push(0xe32323);
		mInventory.push(0x454dee);
		mInventory.push(0x0fa90f);
		
		mEquipedItem = 0;
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		
		mStandAnimR = new Animation([0],1);
		mWalkAnimR = new Animation([1, 2, 3], 10);
		mStandAnimL = new Animation([4],1);
		mWalkAnimL = new Animation([7, 6, 5], 10);
		
		mJumpAnimR = new Animation([1], 1);
		mJumpAnimL = new Animation([7], 1);
		mFallAnimR = new Animation([2], 1);
		mFallAnimL = new Animation([6], 1);
		
		mStandAnimRFiring = new Animation([8], 1);
		mWalkAnimRFiring = new Animation([9, 10, 11], 10);
		mStandAnimLFiring = new Animation( [12], 1);
		mWalkAnimLFiring = new Animation( [15, 14, 13], 10);
		
		mJumpAnimRFiring  = new Animation([9], 1);
		mJumpAnimLFiring  = new Animation([15], 1);
		mFallAnimRFiring  = new Animation([10], 1);
		mFallAnimLFiring  = new Animation([14], 1);
	}
	
	function onMouseDown(e:MouseEvent) : Void {
		mFiring = true;
		mLaser = new Laser(mLevel, mInventory[mEquipedItem]);
		mLevel.add(mLaser);
		var cam = mLevel.getCamera();
		if (cam != null)
			cam.startShake(2);
	}
	
	function onMouseUp(e : MouseEvent) : Void {
		mFiring = false;
		mLaser.destroy();
		mLaser = null;
		var cam = mLevel.getCamera();
		if (cam != null)
			cam.stopShake();
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
		switch (e.keyCode) {
			case Keyboard.SPACE :
				mJumpDown = false;
			case Keyboard.Q :
				if(mXAxis == -1){
					mXAxis = 0;
				}
			case Keyboard.D :
				if(mXAxis == 1){
					mXAxis = 0;
				}
		}
	}
	
	private function onKeyDown(e:KeyboardEvent):Void 
	{
		switch (e.keyCode) {
			case Keyboard.SPACE :
				mJumpDown = true;
			case Keyboard.Q :
				mXAxis = -1;
			case Keyboard.D :
				mXAxis = 1;
			case Keyboard.NUMBER_1 :
				mEquipedItem = 0;
				mChangedWeapon = true;
			case Keyboard.NUMBER_2 :
				mEquipedItem = 1;
				mChangedWeapon = true;
			case Keyboard.NUMBER_3 :
				mEquipedItem = 2;
				mChangedWeapon = true;
		}
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		if (mChangedWeapon && mLaser != null) {
			mChangedWeapon = false;
			mLaser.destroy();
			mLaser = new Laser(mLevel, mInventory[mEquipedItem]);
			mLevel.add(mLaser);
		}
		
		if (mOnFloor && mJumpDown)
			vel.y -= JUMP_STRENGHT;
		
		var mAxisSameAsVel = (
			mXAxis < 0 && vel.x < 0 ||
			mXAxis > 0 && vel.x > 0
			);
			
		if (mOnFloor && mAxisSameAsVel)
			mFloorFriction = 1;
		else 
			mFloorFriction = 0.75;
			
		if (!mOnFloor && mAxisSameAsVel)
			mAirFriction = 1;
		else
			mAirFriction = 0.9;
			
			
		vel.x += mXAxis * delta * WALK_STRENGTH;
		
		if(!mFiring)
			if (mXAxis > 0) 
				mLookingDir = 1;
			else if (mXAxis < 0)
				mLookingDir = -1;
			
		if (mFiring) {
			var xLaser = mLookingDir * 4;
			if (mLookingDir < 0) xLaser = mLookingDir * 5;
			mLaser.pos.set(pos.x + mDim.x / 2 + xLaser, pos.y + 5);
			
			var endX = Lib.current.stage.mouseX/2 - mLevel.pos.x;
			var endY = Lib.current.stage.mouseY / 2 - mLevel.pos.y;
			
			if (endX >= pos.x +mDim.x / 2)
				mLookingDir = 1;
			else
				mLookingDir = -1;
			mLaser.setEndPos(new Vec2(endX, endY));
			vel.sub(Vec2.Mul(Vec2.Norm(mLaser.getDir()), delta * 500));
		
			if (mLookingDir > 0 && vel.x > 25) 
				if(mOnFloor)
					setAnimation(mWalkAnimRFiring);
				else 
					if (vel.y < 0)
						setAnimation(mJumpAnimRFiring);
					else
						setAnimation(mFallAnimRFiring);
			else if (mLookingDir < 0 && vel.x < -25)
				if(mOnFloor)
					setAnimation(mWalkAnimLFiring);
				else
					if (vel.y < 0)
						setAnimation(mJumpAnimLFiring);
					else
						setAnimation(mFallAnimLFiring);
			else 
				if (mLookingDir > 0)
					if (mOnFloor) setAnimation(mStandAnimRFiring);
					else 
						if (vel.y < 0)
							setAnimation(mJumpAnimRFiring);
						else
							setAnimation(mFallAnimRFiring);
				else
					if (mOnFloor) setAnimation(mStandAnimLFiring);
					else 
						if (vel.y < 0)
						setAnimation(mJumpAnimLFiring);
					else
						setAnimation(mFallAnimLFiring);
		}
		else
			if (mLookingDir > 0 && vel.x > 25) 
				if(mOnFloor)
					setAnimation(mWalkAnimR);
				else 
					if (vel.y < 0)
						setAnimation(mJumpAnimR);
					else
						setAnimation(mFallAnimR);
			else if (mLookingDir < 0 && vel.x < -25)
				if(mOnFloor)
					setAnimation(mWalkAnimL);
				else
					if (vel.y < 0)
						setAnimation(mJumpAnimL);
					else
						setAnimation(mFallAnimL);
			else 
				if (mLookingDir > 0)
					if (mOnFloor) setAnimation(mStandAnimR);
					else 
						if (vel.y < 0)
							setAnimation(mJumpAnimR);
						else
							setAnimation(mFallAnimR);
				else
					if (mOnFloor) setAnimation(mStandAnimL);
					else 
						if (vel.y < 0)
						setAnimation(mJumpAnimL);
					else
						setAnimation(mFallAnimL);
		
		if (vel.x > 250)
			vel.x = 250;
		if (vel.x < -250)
			vel.x = -250;
	}
	
}