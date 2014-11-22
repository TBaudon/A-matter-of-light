package entities;
import core.Actor;

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
	
}