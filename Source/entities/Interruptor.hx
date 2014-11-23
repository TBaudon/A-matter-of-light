package entities;
import core.Actor;

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
	
}