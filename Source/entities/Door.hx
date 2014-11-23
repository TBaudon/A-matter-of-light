package entities;
import core.Actor;
import geom.Vec2;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Thomas B
 */
class Door extends Actor
{
	
	var mTargetMap : String;
	var mTargetX : Float;
	var mTargetY : Float;

	public function new() 
	{
		super(null);
		setDim(16, 16);
		mStatic = true;
	}
	
	override public function setProperties(props:Dynamic) 
	{
		super.setProperties(props);
		
		mTargetMap = props.to;
		mTargetX = props.x;
		mTargetY = props.y;
	}
	
	override public function onCollideOther(actor:Actor, delta : Float) 
	{
		super.onCollideOther(actor, delta);
		
		if (Std.is(actor, Hero)) {
			mLevel.pause();
			mLevel.changeTo(mTargetMap);
			actor.pos.x = mTargetX;
			actor.pos.y = mTargetY + (16 - actor.getDim().y);
		}
	}
	
}