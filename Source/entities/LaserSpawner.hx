package entities;
import core.Actor;
import core.Animation;
import geom.Vec2;

/**
 * ...
 * @author Thomas BAUDON
 */
class LaserSpawner extends Mecanism
{
	
	var mLaser : Laser;
	var mLaserAdded : Bool;
	var mLaserColor : UInt;
	var mLaserAngle : Float;
	var mLaserStartPos : Vec2;
	
	var mAnimTop : Animation;
	var mAnimRight : Animation;
	var mAnimLeft : Animation;
	var mAnimBottom : Animation;

	public function new() 
	{
		super("LaserSpawner");
		setDim(16, 16);
		
		mAnimRight = new Animation([0], 1);
		mAnimTop = new Animation([1], 1);
		mAnimBottom = new Animation([2], 1);
		mAnimLeft = new Animation([3], 1);
		
		mLaserStartPos = new Vec2();
		
		mSolid = true;
		mStatic = true;
	}
	
	override public function setProperties(props:Dynamic) 
	{
		super.setProperties(props);
		mLaserAngle = props.angle;
		var innerDist : Int = 3;
		
		if (mLaserAngle > -135 && mLaserAngle <= -45) {
			mLaserStartPos.x = mDim.x / 2;
			mLaserStartPos.y = 0 + innerDist;
			setAnimation(mAnimTop);
		}
		else if (mLaserAngle > -45 && mLaserAngle <= 45) {
			setAnimation(mAnimRight);
			mLaserStartPos.x = mDim.x - innerDist;
			mLaserStartPos.y = mDim.y / 2;
		}
		else if (mLaserAngle > 45 && mLaserAngle <= 135) {
			setAnimation(mAnimBottom);
			mLaserStartPos.x = mDim.x / 2;
			mLaserStartPos.y = mDim.y - innerDist;
		}
		else if (mLaserAngle > 135 && mLaserAngle <= -135) {
			setAnimation(mAnimLeft);
			mLaserStartPos.x = 0 + innerDist;
			mLaserStartPos.y = mDim.y / 2;
		}
		
		mLaserColor = Laser.getColor(props.color);
	}	
	
	override function activate() 
	{
		super.activate();
		mLaser = new Laser(Vec2.Add(pos, mLaserStartPos), mLevel, mLaserColor);
		mLaser.setAngle(mLaserAngle / 180 * Math.PI);
		mLevel.add(mLaser);
	}
	
	override function deactivate() 
	{
		super.deactivate();
		mLaser.destroy();
	}
}