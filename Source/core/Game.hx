package core ;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.events.Event;
import openfl.system.System;

/**
 * ...
 * @author Thomas BAUDON
 */
class Game extends Sprite
{
	var mLastTime : UInt;
	
	// rendering
	var mPixelSize : UInt;
	var mBuffer : BitmapData;
	var mClearRect : Rectangle;
	var mCanvas : Bitmap;
	
	var mDeltas : Array<Float>;
	var mCurrentDelta : Int;
	var mDelta : Float;
	var mDeltaSample : Int = 30;
	
	// screen
	var mCurrentScreen : Screen;
	
	static var mInstance : Game;
	
	public static function init(pixelSize : UInt = 3) : Game {
		if (mInstance == null)
			mInstance = new Game(pixelSize);
		return mInstance;
	}
	
	public static function getInstance() : Game {
		return mInstance;
	}

	function new(pixelSize : UInt = 2) 
	{
		super();
		
		mDeltas = new Array<Float>();
		for (i in 0 ... mDeltaSample)
			mDeltas.push(0.016);
		mCurrentDelta = mDeltas.length - 1;
		
		initRender(pixelSize);
		
		addEventListener(Event.ENTER_FRAME, update);
		mLastTime = Lib.getTimer();
	}
	
	public function gotoScreen(screen : Screen) {
		if (mCurrentScreen != null)
			mCurrentScreen.destroy();
			
		mCurrentScreen = screen;
	}
	
	function initRender(pixelSize:UInt) 
	{
		mPixelSize = pixelSize;
		var bW : Int = Std.int(Lib.current.stage.stageWidth / mPixelSize);
		var bH : Int = Std.int(Lib.current.stage.stageHeight / mPixelSize);
		mBuffer = new BitmapData(bW, bH, false, 0);
		mClearRect = new Rectangle(0, 0, bW, bH);
		
		mCanvas = new Bitmap(mBuffer, PixelSnapping.ALWAYS, false);
		mCanvas.scaleX = mPixelSize;
		mCanvas.scaleY = mPixelSize;
		Lib.current.stage.addChild(mCanvas);
	}
	
	function update(e :Event) {
		
		var time = Lib.getTimer();
		var delta = (time - mLastTime) / 1000;
		mLastTime = time;
		
		mCurrentDelta++;
		if (mCurrentDelta == mDeltas.length) {
			mCurrentDelta = 0;
			mDelta = 0;
			for (d in mDeltas)
				mDelta += d;
			mDelta = mDelta / mDeltas.length;
		}
		
		mDeltas[mCurrentDelta] = delta;
		
		if (mCurrentScreen != null){
			mCurrentScreen._update(mDelta);
			render();
		}
	}
	
	function render() : Void 
	{
		mBuffer.lock();
		mBuffer.fillRect(mClearRect, 0);
		
		mCurrentScreen._draw(mBuffer, mCurrentScreen.pos);
			
		mBuffer.unlock();
	}
	
}