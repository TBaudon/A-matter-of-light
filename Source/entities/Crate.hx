package entities;
import core.Actor;
import core.Entity;

/**
 * ...
 * @author Thomas BAUDON
 */
class Crate extends Actor
{

	public function new() 
	{
		super("crate");
		mSolid = true;
		setDim(16, 16);
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
	}
	
}