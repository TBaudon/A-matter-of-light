package core;
import geom.Vec2;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Matrix;
import openfl.text.AntiAliasType;
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
	var mFormat : TextFormat;
	var mWidth : Float;
	
	var mBg : Shape;

	public function new(text : String) 
	{
		super("Dialog");
		mText = text;
		mDialogTxt = new TextField();
		
		mFormat = new TextFormat(Assets.getFont('fonts/nokiafc22.ttf').fontName, 8, 0xffffff);
		mDialogTxt.wordWrap = true;
		mDialogTxt.multiline = true;
		mDialogTxt.embedFonts = true;
		mDialogTxt.selectable = false;
		mDialogTxt.antiAliasType = AntiAliasType.NORMAL;
		mDialogTxt.sharpness = 100;
		mWidth = Game.getInstance().getWidth() / 2;
		mDialogTxt.width = mWidth;
		mDialogTxt.height = 24;
		mTimeToNext = 0;
		mCarretCounter = 0;
		mCarretPos = 0;
		mMat = new Matrix();
		
		mBg = new Shape();
		mBg.graphics.beginFill(0, 0.5);
		mBg.graphics.drawRect( -3, -3, mWidth + 6, mDialogTxt.height + 6);
		mBg.graphics.endFill();
		mBg.graphics.lineStyle(1, 0xffffff);
		mBg.graphics.drawRect( -3, -3, mWidth + 6, mDialogTxt.height + 6);
	}
	
	override public function update(delta:Float) {
		mCarretCounter += delta;
		if (mCarretCounter >= mTimeToNext && mCarretPos < mText.length) {
			mDialogTxt.text += mText.charAt(mCarretPos);
			mDialogTxt.setTextFormat(mFormat);
			puaseToNext(mText.charAt(mCarretPos));
			mCarretPos++;
			mCarretCounter = 0;
			mDialogTxt.scrollV = mDialogTxt.numLines + 1;
		}
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		mMat.identity();
		mMat.translate((Game.getInstance().getWidth() - mWidth) / 2, 20);
		buffer.draw(mBg, mMat);
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