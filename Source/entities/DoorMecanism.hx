package entities;
import core.Animation;

/**
 * ...
 * @author Thomas BAUDON
 */
class DoorMecanism extends Mecanism
{

	var mOpenAnimation : Animation;
	var mCloseAnimation : Animation;
	
	public function new() 
	{
		super("Door");
		setDim(16, 16);
		mSolid = true;
		mStatic = true;
		
		mOpenAnimation = new Animation([1, 2, 3], 12, false);
		mCloseAnimation = new Animation([3, 2, 1, 0], 12, false);
		setAnimation(mCloseAnimation);
	}
	
	override function activate() 
	{
		super.activate();
		setAnimation(mOpenAnimation);
		mSolid = false;
	}
	
	override function deactivate() 
	{
		super.deactivate();
		setAnimation(mCloseAnimation);
		mSolid = true;
	}
	
}