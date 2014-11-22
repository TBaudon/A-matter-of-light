package entities;
import core.Actor;

/**
 * ...
 * @author Thomas BAUDON
 */
class LaserSpawner extends Actor
{
	
	var mLaser : Laser;
	var mLaserAdded : Bool;

	public function new() 
	{
		super();
		
		mStatic = true;
		mSolid = false;
	}
	
	override public function setProperties(props:Dynamic) 
	{
		super.setProperties(props);
		
		mLaser = new Laser(pos, mLevel, Laser.getColor(props.color));
		mLaser.setAngle(props.angle/180*Math.PI);
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		mLaser.pos.x = pos.x;
		mLaser.pos.y = pos.y;
		
		if (!mLaserAdded){
			mLevel.add(mLaser);
			mLaserAdded = true;
		}
	}
	
	
	
}