package core;

/**
 * ...
 * @author Thomas B
 */
class Animation
{
	
	var mFrames : Array<Int>;
	var mCurrentFrame : Int;
	var mTimeCounter : Float;
	var mTimeToNextFrame : Float;
	
	public function new(frames : Array<Int>, fps : Int) 
	{
		mFrames = frames;
		mCurrentFrame = 0;
		mTimeToNextFrame = 1 / fps;
		mTimeCounter = 0;
	}
	
	public function getNextFrame(delta : Float) : Int {
		mTimeCounter += delta;
		if (mTimeCounter >= mTimeToNextFrame){
			mTimeCounter = 0;
			mCurrentFrame ++;
		}
		
		if (mCurrentFrame == mFrames.length)
			mCurrentFrame = 0;
			
		return mFrames[mCurrentFrame];
	}
	
	
	
}