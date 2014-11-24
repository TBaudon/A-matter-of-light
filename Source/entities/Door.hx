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
		mSolid = false;
	}
	
	override public function setProperties(props:Dynamic) 
	{
		super.setProperties(props);
		
		mTargetMap = props.to;
		mTargetX = props.x;
		mTargetY = props.y;
	}
	
	override function onCollideOtherFromAnyWhere(actor:Actor) 
	{
		super.onCollideOtherFromAnyWhere(actor);
		
		if (Std.is(actor, Hero)) {
			mLevel.pause();
			mLevel.changeTo(mTargetMap);
			actor.pos.x = mTargetX;
			actor.pos.y = mTargetY + (16 - actor.getDim().y);
		}
	}
	
	#if debug
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		buffer.fillRect(new Rectangle(dest.x, dest.y, 16, 16), 0x006633);
	}
	#end
}