package entities;
import core.Actor;
import geom.Vec2;
import haxe.Timer;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;

/**
 * ...
 * @author Thomas BAUDON
 */
class Particle extends Actor
{
	var mDrawRect:Rectangle;
	var mColor : UInt;
	var mLifeTime : Float;
	var mTimeSinceBorn : Float;

	public function new(color : UInt = 0xff0000, lifeTime : Float = 1.0, dim : UInt = 2) 
	{
		super(null);
		setDim(dim, dim);
		
		mSolid = false;
		mStatic = false;
		
		mColor = color;
		mLifeTime = lifeTime;
		mTimeSinceBorn = 0;
		Timer.delay(destroy, Std.int(lifeTime * 1000));
		
		mDrawRect = new Rectangle(0, 0, dim, dim);
		
		var angle = Math.random() * 360;
		var speed = Math.random() * 500 + 250;
		vel.x = Math.cos(angle) * speed;
		vel.y = Math.sin(angle) * speed;
	}
	
	public function SetRandomSpeed(min : Float, max : Float) {
		var angle = Math.random() * 360;
		var speed = Math.random() * (max - min) + min;
		vel.x = Math.cos(angle) * speed;
		vel.y = Math.sin(angle) * speed;
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		mDrawRect.x = dest.x;
		mDrawRect.y = dest.y;
		buffer.fillRect(mDrawRect, mColor);
	}
	
}