package entities;
import core.Animation;
import core.Game;
import entities.Hero;
import geom.Vec2;
import haxe.Timer;
import openfl.display.BitmapData;

/**
 * ...
 * @author Thomas BAUDON
 */
class LaserPill extends Collectible
{
	
	var mRedAnim : Animation;
	var mGreenAnim : Animation;
	var mBlueAnim : Animation;
	
	var mColor : UInt;
	
	var mBlinking : Bool;
	var mBlinkSpeed : Float;
	var mBlinkTime : Float;
	var mTotalBlinkTime : Float;
	var mBlinkDuration : Float;
	
	var mLasers : Array<Laser>;
	var mExploded : Bool;
	var mAlreadyCollected : Bool;
	
	var mRandomFlashTime : Float;
	var mRandomFlashCounter : Float;
	
	var mExplodedSince : Float;
	var mShowedExplodeDialog : Bool;
	
	var mHero : Hero;

	public function new() 
	{
		super('LaserPill');
		setDim(8, 8);
		mSpriteSheet.setFrameDim(8, 8);
		mBlinkSpeed = 0.02;
		mBlinkDuration = 2;
		mTotalBlinkTime = 0;
		mLasers = new Array<Laser>();
		mAlreadyCollected = false;
		mRandomFlashTime = Math.random() * 3;
		mRandomFlashCounter = 0;
		mExplodedSince = 0;
	}
	
	override public function setProperties(props:Dynamic) 
	{
		super.setProperties(props);
		switch(props.color)
		{
			case 0 :
				setAnimation(mRedAnim);
			case 1 :
				setAnimation(mGreenAnim);
			case 2 : 
				setAnimation(mBlueAnim);
		}
		mColor = props.color;
	}
	
	override function update(delta : Float) {
		super.update(delta);
		if(mBlinking){
			mBlinkTime += delta;
			mTotalBlinkTime += delta;
			pos.y = mAddY - (mTotalBlinkTime / mBlinkDuration) * 25;
			mHero.pos.x = pos.x + 4 - mHero.getDim().x / 2;
			mHero.pos.y = pos.y + 4 - mHero.getDim().y / 2;
			mHero.visible = !visible;
			if (mBlinkTime >= mBlinkSpeed)
			{
				mBlinkTime = 0;
				visible = !visible;
			}
			
			if (mTotalBlinkTime >= mBlinkDuration){
				//destroy();
				explode();
			}
		}
		
		if (mExploded) {
			mHero.BLARGWARGWARW();
			for (laser in mLasers) {
				var newAngle = laser.getAngle() + 0.01;
				laser.setAngle(newAngle);
				laser.pos = Vec2.Add(pos, new Vec2(Math.cos(newAngle) * 10 + 4, Math.sin(newAngle) * 10 + 4));
			}
			
			mRandomFlashCounter += delta;
			if (mRandomFlashCounter >= mRandomFlashTime) {
				Game.getInstance().flash(0xffffff, 0.15);
				mRandomFlashCounter = 0;
				mRandomFlashTime = Math.random() * 2;
			}
			
			mExplodedSince += delta;
			if (!mShowedExplodeDialog && mExplodedSince > 3) {
				showDialog();
				mShowedExplodeDialog = true;
			}
		}
	}
	
	function showDialog() 
	{
		switch(mColor) {
			case 0 : 
				mLevel.getGameScreen().showEventDialog("redTaken", gotoLevel5);
		}
	}
	
	function gotoLevel5() {
		mLevel.getGameScreen().loadLevel("level5");
		Game.getInstance().flash(0xffffff, 2);
	}
	
	function explode() {
		mBlinking = false;
		mHero.visible = true;
		visible = false;
		mAddY -= 25;
		var nbLaser = 6;
		for (i in 0 ... nbLaser) {
			var angle = (Math.PI * 2) / nbLaser * i; 
			var laser = new Laser(Vec2.Add(pos, new Vec2(Math.cos(angle) * 10 + 4, Math.sin(angle) * 10 + 4)), mLevel, Laser.getColor(mColor));
			laser.setAngle(angle);
			mLevel.add(laser);
			mLasers.push(laser);
		}
		mExploded = true;
		mLevel.getCamera().startShake(5);
		Game.getInstance().flash(0xffffff, 1);
	}
	
	override function onCollected(hero:Hero) 
	{
		if (!mAlreadyCollected) {
			mHero = hero;
			mHero.setStatic(true);
			mHero.removeListeners();
			hero.giveLaser(mColor);
			Game.getInstance().flash(0xffffff, 0.1);
			mBlinking = true;
			mBlinkTime = 0;
			mAlreadyCollected = true;
		}
	}
	
}