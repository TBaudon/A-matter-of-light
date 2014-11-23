package entities;
import core.Actor;
import entities.Mecanism;

/**
 * ...
 * @author Thomas BAUDON
 */
class Interruptor extends Actor
{
	
	var mActive : Bool;

	public function new(spriteSheet : String) 
	{
		super(spriteSheet);
	}
	
	public function isActive(): Bool {
		return mActive;
	}
	
	override function update(delta:Float) 
	{
		mActive = false;
		super.update(delta);
	}
	
}