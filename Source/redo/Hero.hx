package redo;
import geom.Vec2;
import openfl.display.BitmapData;
import openfl.events.KeyboardEvent;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Thomas BAUDON
 */
class Hero extends Actor
{
	
	var mJumpDown : Bool;
	var mXAxis : Float;

	public function new(level : Level) 
	{
		super(level);
		mXAxis = 0;
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
		switch (e.keyCode) {
			case Keyboard.SPACE :
				mJumpDown = false;
			case Keyboard.Q :
				mXAxis = 0;
			case Keyboard.D :
				mXAxis = 0;
		}
	}
	
	private function onKeyDown(e:KeyboardEvent):Void 
	{
		switch (e.keyCode) {
			case Keyboard.SPACE :
				mJumpDown = true;
			case Keyboard.Q :
				mXAxis = -1;
			case Keyboard.D :
				mXAxis = 1;
		}
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		if (mOnFloor && mJumpDown)
			vel.y -= 340;
			
		vel.x += mXAxis * delta * 1000;
	}
	
}