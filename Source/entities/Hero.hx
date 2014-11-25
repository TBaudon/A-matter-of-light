package entities ;
import core.Actor;
import core.Animation;
import core.Entity;
import entities.Laser;
import core.Level;
import geom.Vec2;
import haxe.Timer;
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
	var mEquipedItem : Int;
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
	var mStandAnimLFiring : Animation;
	var mWalkAnimRFiring : Animation;
	var mWalkAnimLFiring : Animation;
	var mJumpAnimRFiring : Animation;
	var mJumpAnimLFiring : Animation;
	var mFallAnimRFiring : Animation;
	var mFallAnimLFiring : Animation;
	
	inline static var WALK_STRENGTH : Int = 600;
	
	var mLookingDir : Int;
	
	static private inline var JUMP_STRENGHT:Float = 430;
	static private inline var MAX_X_VEL:Float = 150;
	
	var mJumpTime : Float;

	public function new() 
	{
		super("hero");
		name = "Hero";
		mSpriteSheet.offsetX = 5;
		mSpriteSheet.offsetY = 4;
		setDim(6, 12);
		mXAxis = 0;
		
		mLookingDir = 1;
		
		mSolid = true;
		
		mInventory = new Array<UInt>();
		
		#if debug
		mInventory.push(Laser.getColor(0));
		mInventory.push(Laser.getColor(1));
		mInventory.push(Laser.getColor(2));
		#end
		
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
		if(mInventory.length > mEquipedItem){
			mFiring = true;
			mLaser = new Laser(pos, mLevel, mInventory[mEquipedItem]);
			mLaser.setSpawner(this);
			mLevel.add(mLaser);
			var cam = mLevel.getCamera();
			if (cam != null)
				cam.startShake(2);
		}
	}
	
	function onMouseUp(e : MouseEvent) : Void {
		mFiring = false;
		if (mLaser != null)		
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
			case Keyboard.R :
				die();
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
		if (mDead) return;
		super.update(delta);
		
		if (mChangedWeapon && mLaser != null) {
			mChangedWeapon = false;
			mLaser.setColor(mInventory[mEquipedItem]);
		}
		
		if (mOnFloor && mJumpDown) {
			mJumpTime = 0;
			vel.y -= JUMP_STRENGHT * delta * 8;
		}else if(mJumpDown){
			mJumpTime += delta;
			if(mJumpTime < 0.14)
				 vel.y -= JUMP_STRENGHT * delta * 8;
		}
		
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
			
			var endX = mLevel.getPointer().pos.x - mLevel.pos.x;
			var endY = mLevel.getPointer().pos.y - mLevel.pos.y;
			
			if (endX >= pos.x +mDim.x / 2)
				mLookingDir = 1;
			else
				mLookingDir = -1;
				
			mLaser.setAngle(Math.atan2(endY-(pos.y+mDim.y/2), endX-(pos.x+mDim.x/2)));
			
			onFiringLaser(delta);
		
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
		
		if (vel.x > MAX_X_VEL)
			vel.x = MAX_X_VEL;
		if (vel.x < -MAX_X_VEL)
			vel.x = -MAX_X_VEL;
	}
	
	override function onHurt() 
	{
		super.onHurt();
		
		die();
	}
	
	override function onDie() 
	{
		super.onDie();
		
		mLevel.getCamera().shake(7, 300);
		for (i in 0 ... 50)
		{
			var b = new BloodParticle();
			b.pos.copy(pos);
			b.setLevel(mLevel);
			mLevel.add(b);
		}
		destroy();
		Timer.delay(mLevel.restart, 1000);
	}
	
	function onFiringLaser(delta : Float) 
	{
		if(mLaser.getCol() == 0xff0000)
			vel.sub(Vec2.Mul(Vec2.Norm(mLaser.getDir()), delta * 500 * mTimeMutiplier));
	}
	
	public function giveLaser(code : UInt) {
		mInventory.push(Laser.getColor(code));
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		if(!mDead)
			super.draw(buffer, dest);
	}
	
}