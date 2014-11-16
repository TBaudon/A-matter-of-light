package core;
import geom.Vec2;

/**
 * ...
 * @author Thomas BAUDON
 */
class Camera
{
	
	var mTargetEntity : Entity;
	var mShakeIntensity:Int;
	var mShakeTime:Int;
	var mShakePhase : Int;
	var mShakeOffsetX : Int;
	var mShakeOffsetY : Int;
	
	public var pos : Vec2;

	public function new() 
	{
		pos = new Vec2();
	}
	
	public function setTarget(ent : Entity) {
		mTargetEntity = ent;
	}
	
	public function update(delta : Float) {
		if (mTargetEntity != null) {
			if (mTargetEntity.pos.x - pos.x > 300)
				pos.x = mTargetEntity.pos.x - 300;
			if (mTargetEntity.pos.x - pos.x < 100)
				pos.x = mTargetEntity.pos.x - 100;
			if (mTargetEntity.pos.y - pos.y > 190)
				pos.y = mTargetEntity.pos.y - 190;
			if (mTargetEntity.pos.y - pos.y < 50)
				pos.y = mTargetEntity.pos.y - 50;
		}
		
		if (mShakeTime > 0)
		{
			if (mShakePhase == 0) {
				mShakeOffsetX = cast Math.random() * mShakeIntensity * 2 - mShakeIntensity;
				mShakeOffsetY = cast Math.random() * mShakeIntensity * 2 - mShakeIntensity;
			}else {
				mShakeOffsetX = -mShakeOffsetX;
				mShakeOffsetY = -mShakeOffsetY;
			}
			
			pos.x += mShakeOffsetX;
			pos.y += mShakeOffsetY;
			
			mShakeTime -= cast 1000 * delta;
			
			if (mShakeTime <= 0) {
				if(mShakePhase == 0){
					pos.x -= mShakeOffsetX;
					pos.y -= mShakeOffsetY;
				}
			}
			
			mShakePhase ++;
			if (mShakePhase > 1)
				mShakePhase = 0;
		}
	}
	
	public function shake(intensity : Int, time : Int) {
		mShakeIntensity = intensity;
		mShakeTime = time;
		mShakePhase = 0;
	}
	
}