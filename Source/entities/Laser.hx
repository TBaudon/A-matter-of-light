package entities ;
import core.Actor;
import core.Entity;
import core.Level;
import core.TileInfo;
import core.Utils;
import geom.Vec2;
import haxe.Log;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.filters.GlowFilter;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Thomas BAUDON
 */
class Laser extends Entity
{
	
	var mLevel : Level;
	var mAngle : Float;
	var mFiring : Bool;
	
	var mStartX : Int;
	var mStartY : Int;
	
	var mEndX : Int;
	var mEndY : Int;
	
	var mDir : Vec2;
	
	var mDrawLine : Shape;
	
	var mEndPos:Vec2;
	
	var mTile : Array<{x : Int, y : Int}>;
	
	var mColor : UInt;
	
	var mImpact : Bool;
	
	var mNextLaser : Laser;
	
	var mReflectNum : UInt;
	
	static var mAllLaser : Array<Laser>;
	
	inline static var MAX_REFLECT : UInt = 25;
	
	public static function getColor(code : Int) : UInt {
		switch(code) {
			case 0 :
				return 0xe32323;
			case 1 :
				return 0x454dee;
			case 2 :
				return 0x0fa90f;
		}
		return 0;
	}
	
	public function new(level : Level, color : UInt = 0xff0000, reflectNum : UInt = 0) 
	{
		super();
		
		if (mAllLaser == null)
			mAllLaser = new Array<Laser>();
		mAllLaser.push(this);
		
		mReflectNum = reflectNum;
		mLevel = level;
		mAngle = 0;
		mFiring = false;
		mDir = new Vec2();
		mDrawLine = new Shape();
		mColor = color;
		mEndPos = new Vec2();
	}
	
	public function setAngle(angle : Float) {
		mAngle = angle / Math.PI * 180;
		
		var x = Math.cos(angle) * 10000;
		var y = Math.sin(angle) * 10000;
		
		mDir.set(x, y);
	}
	
	public function setDir(x : Float, y : Float) {
		mDir.set(x, y);
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		mImpact = false;
		
		var end : RaycastData = mLevel.castRay(pos.x, pos.y, pos.x + mDir.x, pos.y + mDir.y);
		if (end != null) {
			mEndPos = end.hitPos;
			mImpact = true;
			if (Std.is(end.object, TileInfo)) {
				var tileInfo : TileInfo = end.object;
				if (tileInfo.reflect && mReflectNum < MAX_REFLECT)
					reflect(end.from, tileInfo);
				else if (mNextLaser != null){
					mNextLaser.destroy();
					mNextLaser = null;
				}
			}
		} 
	}
	
	function reflect(from:HitDirection, tileInfo:TileInfo) 
	{
		if (mNextLaser == null){
			mNextLaser = new Laser(mLevel, mColor, mReflectNum + 1);
			mLevel.add(mNextLaser);
		}
			
		if (from == HitDirection.BOTTOM && tileInfo.reflectPos == "bottom")
		{
			mNextLaser.pos.x = mEndPos.x;
			mNextLaser.pos.y = mEndPos.y;
			mNextLaser.setDir(mDir.x, -mDir.y);
		}else if (from == HitDirection.LEFT && tileInfo.reflectPos == "left")
		{
			mNextLaser.pos.x = mEndPos.x;
			mNextLaser.pos.y = mEndPos.y;
			mNextLaser.setDir(-mDir.x, mDir.y);
		}else if (from == HitDirection.TOP && tileInfo.reflectPos == "top")
		{
			mNextLaser.pos.x = mEndPos.x;
			mNextLaser.pos.y = mEndPos.y;
			mNextLaser.setDir(mDir.x, -mDir.y);
		}else if (from == HitDirection.RIGHT && tileInfo.reflectPos == "right")
		{
			mNextLaser.pos.x = mEndPos.x;
			mNextLaser.pos.y = mEndPos.y;
			mNextLaser.setDir(-mDir.x, mDir.y);
		}else {
			mNextLaser.destroy();
			mNextLaser = null;
		}
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		
		mDrawLine.graphics.clear();
		mDrawLine.graphics.lineStyle(5, mColor, 0.8);
		mDrawLine.graphics.moveTo(dest.x,dest.y);
		mDrawLine.graphics.lineTo(dest.x + (mEndPos.x - pos.x), dest.y + (mEndPos.y - pos.y));
		
		mDrawLine.graphics.lineStyle(2, 0xffffff, 0.8);
		mDrawLine.graphics.moveTo(dest.x,dest.y);
		mDrawLine.graphics.lineTo(dest.x + (mEndPos.x - pos.x), dest.y + (mEndPos.y - pos.y));
		mDrawLine.filters = [new GlowFilter(mColor)];
		
		if (mImpact) {
			var radius = Math.random() * 5 + 3;
			mDrawLine.graphics.lineStyle(0, 0, 0);
			mDrawLine.graphics.beginFill(0xffffff, 0.8);
			mDrawLine.graphics.drawCircle(dest.x + (mEndPos.x - pos.x), dest.y + (mEndPos.y - pos.y), radius);
		}
		
		buffer.draw(mDrawLine);
	}
	
	public function getDir() : Vec2 {
		return mDir;
	}
	
	override public function destroy() 
	{
		super.destroy();
		mAllLaser.remove(this);
		if (mNextLaser != null)
			mNextLaser.destroy();
	}
	
}