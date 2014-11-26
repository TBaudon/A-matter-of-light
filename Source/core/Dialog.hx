package core;
import geom.Vec2;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Thomas B
 */
class Dialog extends Entity
{
	
	var mDialogTxt : TextField;
	var mCurrentCharPos : UInt;
	
	var mTimeToNext : Float;
	var mCarretCounter : Float;
	var mCarretPos : Int;
	var mText : String;
	var mMat : Matrix;

	public function new(text : String) 
	{
		super("Dialog");
		mText = text;
		mDialogTxt = new TextField();
		mDialogTxt.defaultTextFormat = new TextFormat("maFont", 8, 0xffffff);
		mDialogTxt.wordWrap = true;
		mDialogTxt.multiline = true;
		mTimeToNext = 0;
		mCarretCounter = 0;
		mCarretPos = 0;
		mMat = new Matrix();
	}
	
	override public function update(delta:Float) {
		mCarretCounter += delta;
		if (mCarretCounter >= mTimeToNext && mCarretPos < mText.length) {
			mDialogTxt.text += mText.charAt(mCarretPos);
			puaseToNext(mText.charAt(mCarretPos));
			mCarretPos++;
			mCarretCounter = 0;
		}
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		mMat.identity();
		mMat.translate(dest.x, dest.y);
		buffer.draw(mDialogTxt, mMat);
	}
	
	function puaseToNext(char : String) 
	{
		switch(char) {
			case '.' :
				mTimeToNext = 0.5;
			case ',' :
				mTimeToNext = 0.3;
			case '!' :
				mTimeToNext = 0.5;
			case '?' :
				mTimeToNext = 0.7;
			default :
				mTimeToNext = 0.05;
		}
	}
	
}