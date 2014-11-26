package entities;
import core.Actor;
import core.Animation;
import openfl.Lib;

/**
 * ...
 * @author Thomas BAUDON
 */
class Button extends Interruptor
{
	
	var mOff : Animation;
	var mOn : Animation;
	
	var mCollisionTime : UInt;

	public function new() 
	{
		super("Button");
		setDim(16, 2);
		
		mSpriteSheet.offsetX = 0;
		mSpriteSheet.offsetY = 14;
		
		mOff = new Animation([0],1);
		mOn = new Animation([1], 1);
		
		setAnimation(mOff);
		
		mSolid = true;
		mStatic = true;
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		if (mActive)
			setAnimation(mOn)
		else
			setAnimation(mOff);
	}
	
	override function onCollideOtherFromTop(actor:Actor) 
	{
		super.onCollideOtherFromTop(actor);
		
		mCollisionTime = Lib.getTimer();
		
		mActive = true;
	}
	
	override function onCollideOtherFromLeft(actor:Actor) {
		super.onCollideOtherFromLeft(actor);
		
		actor.pos.y = pos.y - actor.getDim().y;
		actor.pos.x = pos.x - actor.getDim().x + 1;
	}
	
	override function onCollideOtherFromRight(actor:Actor) {
		super.onCollideOtherFromRight(actor);
		
		actor.pos.y = pos.y - actor.getDim().y;
		actor.pos.x = pos.x + mDim.x - 1;
	}
	
}