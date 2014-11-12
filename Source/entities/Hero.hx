package entities;
import ash.core.Entity;
import components.Transform;

/**
 * ...
 * @author Thomas BAUDON
 */
class Hero extends Entity
{

	public function new() 
	{
		super("Hero");
		
		add(new Transform());
	}
	
}