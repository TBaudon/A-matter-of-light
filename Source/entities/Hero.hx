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
	
	var mStandAnimRFiring : Animation;
	var mWalkAnimRFiring : Animation;
	var mStandAnimLFiring : Animation;
	var mWalkAnimLFiring : Animation;
	
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
		mWalkAnimL = new Animation([5, 6, 7], 10);
		
		mStandAnimRFiring = new Animation([8], 1);
		mWalkAnimRFiring = new Animation([9, 10, 11], 10);
		mStandAnimLFiring = new Animation( [12], 1);
		mWalkAnimLFiring = new Animation( [13, 14, 15], 10);
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
			
		vel.x += mXAxis * delta * 1000;
		
		if(!mFiring)
			if (mXAxis > 0) 
				mLookingDir = 1;
			else if (mXAxis < 0)
				mLookingDir = -1;
			
		if (mFiring) {
		
			mLaser.pos.set(pos.x + mDim.x / 2 + mLookingDir * 7 , pos.y + 4);
			
			var endX = Lib.current.stage.mouseX/2 - mLevel.pos.x;
			var endY = Lib.current.stage.mouseY / 2 - mLevel.pos.y;
			
			if (endX >= pos.x +mDim.x / 2)
				mLookingDir = 1;
			else
				mLookingDir = -1;
			mLaser.setEndPos(new Vec2(endX, endY));
			vel.sub(Vec2.Mul(Vec2.Norm(mLaser.getDir()), delta * 500));
		
			if (mLookingDir > 0 && vel.x > 25) 
				setAnimation(mWalkAnimRFiring);
			else if (mLookingDir < 0 && vel.x < -25)
				setAnimation(mWalkAnimLFiring);
			else 
				if (mLookingDir > 0)
					setAnimation(mStandAnimRFiring);
				else
					setAnimation(mStandAnimLFiring);
		}
		else
			if (mLookingDir > 0 && vel.x > 25) 
				setAnimation(mWalkAnimR);
			else if (mLookingDir < 0 && vel.x < -25) 
				setAnimation(mWalkAnimL);
			else 
				if (mLookingDir > 0)
					setAnimation(mStandAnimR);
				else
					setAnimation(mStandAnimL);
		
		if (vel.x > 200)
			vel.x = 200;
		if (vel.x < -200)
			vel.x = -200;
	}
	
}