package entities;
import core.Actor;

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

	public function new() 
	{
		super(null);
		
		mSolid = false;
		mStatic = true;
	}
	
	override public function setProperties(props:Dynamic) 
	{
		super.setProperties(props);
		mLaserAngle = props.angle;
		mLaserColor = props.color;
	}	
	
	override function activate() 
	{
		super.activate();
		mLaser = new Laser(pos, mLevel, mLaserColor);
		mLaser.setAngle(mLaserAngle / 180 * Math.PI);
		mLevel.add(mLaser);
	}
	
	override function deactivate() 
	{
		super.deactivate();
		mLaser.destroy();
	}
}