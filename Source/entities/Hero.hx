package entities ;
import core.Actor;
import entities.Laser;
import core.Level;
import geom.Vec2;
import openfl.display.BitmapData;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
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
	var mFiring : Bool;
	var mLaser : Laser;

	public function new(level : Level) 
	{
		super(level);
		mXAxis = 0;
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		
	}
	
	function onMouseDown(e:MouseEvent) : Void {
		mFiring = true;
		mLaser = new Laser(mLevel);
		mLevel.add(mLaser);
		var cam = mLevel.getCamera();
		if (cam != null)
			cam.startShake(3);
	}
	
	function onMouseUp(e : MouseEvent) : Void {
		mFiring = false;
		mLaser.destroy();
		mLaser = null;
		var cam = mLevel.getCamera();
		if (cam != null)
			cam.stopShake();
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
		switch (e.keyCode) {
			case Keyboard.SPACE :
				mJumpDown = false;
			case Keyboard.Q :
				if(mXAxis == -1)
					mXAxis = 0;
			case Keyboard.D :
				if(mXAxis == 1)
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
			vel.y -= 200;
			
		vel.x += mXAxis * delta * 1000;
		
		if (vel.x > 200)
			vel.x = 200;
		if (vel.x < -200)
			vel.x = -200;
		
		if (mFiring) {
			mLaser.pos.set(pos.x, pos.y);
			
			var endX = Lib.current.stage.mouseX/2 - mLevel.pos.x;
			var endY = Lib.current.stage.mouseY/2 - mLevel.pos.y;
			mLaser.setEndPos(new Vec2(endX, endY));
		}
	}
	
}