package core ;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.events.Event;

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
	
	// screen
	var mCurrentScreen : Screen;
	
	static var mInstance : Game;
	
	public static function init(pixelSize : UInt = 2) : Game {
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
		
		mCanvas = new Bitmap(mBuffer, PixelSnapping.NEVER, false);
		mCanvas.scaleX = mPixelSize;
		mCanvas.scaleY = mPixelSize;
		Lib.current.stage.addChild(mCanvas);
	}
	
	function update(e :Event) {
		
		var time = Lib.getTimer();
		var delta = (time - mLastTime) / 1000;
		mLastTime = time;
		
		if (mCurrentScreen != null){
			mCurrentScreen._update(delta);
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