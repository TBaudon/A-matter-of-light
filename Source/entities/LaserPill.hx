package entities;
import core.Animation;
import core.Game;
import entities.Hero;

/**
 * ...
 * @author Thomas BAUDON
 */
class LaserPill extends Collectible
{
	
	var mRedAnim : Animation;
	var mGreenAnim : Animation;
	var mBlueAnim : Animation;
	
	var mColor : UInt;

	public function new() 
	{
		super('LaserPill');
		setDim(8, 8);
		mSpriteSheet.setFrameDim(8, 8);
	}
	
	override public function setProperties(props:Dynamic) 
	{
		super.setProperties(props);
		switch(props.color)
		{
			case 0 :
				setAnimation(mRedAnim);
			case 1 :
				setAnimation(mGreenAnim);
			case 2 : 
				setAnimation(mBlueAnim);
		}
		mColor = props.color;
	}
	
	override function onCollected(hero:Hero) 
	{
		hero.giveLaser(mColor);
		Game.getInstance().flash(0xffffff, 0.1);
		super.onCollected(hero);
	}
	
}