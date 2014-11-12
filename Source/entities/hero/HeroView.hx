package entities.hero;
import components.View;
import openfl.display.Sprite;

/**
 * ...
 * @author Thomas BAUDON
 */
class HeroView extends View
{
	
	var mBody : Sprite;
	var mArm : Sprite;

	public function new() 
	{
		super();
		
		mBody = new Sprite();
		mArm = new Sprite();
		
		mBody.graphics.lineStyle(2, 0);
		mBody.graphics.beginFill(0x66ff33);
		mBody.graphics.drawRect( -20, -100, 40, 30);
		mBody.graphics.beginFill(0xffffff);
		mBody.graphics.drawRect( -20, -70, 40, 70);
		mBody.graphics.endFill();
		
		addChild(mBody);
	}
	
}