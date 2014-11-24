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
	
	override function onCollideOtherFromAnyWhere(actor:Actor) 
	{
		super.onCollideOtherFromAnyWhere(actor);
		if (Std.is(actor, Hero)) {
			onCollected(cast (actor));
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