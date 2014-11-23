package entities;
import core.Actor;
import core.Entity;
import openfl.Lib;

/**
 * ...
 * @author Thomas BAUDON
 */
class Collectible extends Actor
{
	
	var mAddY : Float;

	public function new(sprite : String) 
	{
		super(sprite);
		mSolid = false;
		mStatic = true;
	}
	
	override function onCollideOtherFromAnyWhere(downCollition:Actor, topCollision:Actor, leftCollision:Actor, rightCollision:Actor) 
	{
		super.onCollideOtherFromAnyWhere(downCollition, topCollision, leftCollision, rightCollision);
		if (Std.is(downCollition, Hero)) {
			onCollected(cast downCollition);
			return;
		}
		
		if (Std.is(leftCollision, Hero)) {
			onCollected(cast leftCollision);
			return;
		}
		
		if (Std.is(topCollision, Hero)) {
			onCollected(cast topCollision);
			return;
		}
		
		if (Std.is(rightCollision, Hero)) {
			onCollected(cast rightCollision);
			return;
		}
	}
	
	function onCollected(hero : Hero) {
		destroy();
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		pos.y = mAddY + Math.sin(Lib.getTimer() / 250) * 1;
	}
	
	override public function onAdded(p:Entity) 
	{
		super.onAdded(p);
		
		mAddY = pos.y;
	}
	
}