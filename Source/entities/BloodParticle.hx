package entities;
import core.Actor;
import geom.Vec2;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;

/**
 * ...
 * @author Thomas BAUDON
 */
class BloodParticle extends Actor
{
	var mDrawRect:Rectangle;

	public function new() 
	{
		super(null);
		setDim(2, 2);
		mSolid = false;
		mStatic = false;
		
		mDrawRect = new Rectangle(0, 0, 2, 2);
		
		var angle = Math.random() * 360;
		var speed = Math.random() * 500 + 250;
		vel.x = Math.cos(angle) * speed;
		vel.y = Math.sin(angle) * speed;
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		mDrawRect.x = dest.x;
		mDrawRect.y = dest.y;
		buffer.fillRect(mDrawRect, 0xff0000);
	}
	
}