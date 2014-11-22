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
	var mPrevLaser : Laser;
	
	var mReflectNum : UInt;
	
	var mSection : Array <Float>;
	var mSectionColor : Array<UInt>;
	var mNbSection : Int = 0;
	
	static var mAllLaser : Array<Laser>;
	
	inline static var MAX_REFLECT : UInt = 25;
	
	public static function getColor(code : Int) : UInt {
		switch(code) {
			case 0 :
				return 0xFF0000;
			case 1 :
				return 0x00FF00;
			case 2 :
				return 0x0000FF;
		}
		return 0;
	}
	
	public function new(startPos : Vec2, level : Level, color : UInt = 0xff0000, reflectNum : UInt = 0, prev : Laser = null) 
	{
		super();
		
		pos.copy(startPos);
		
		if (mAllLaser == null)
			mAllLaser = new Array<Laser>();
		mAllLaser.push(this);
		
		mReflectNum = reflectNum;
		mPrevLaser = prev;
		mLevel = level;
		mAngle = 0;
		mFiring = false;
		mDir = new Vec2();
		mDrawLine = new Shape();
		mColor = color;
		mEndPos = new Vec2();
		mSection = new Array<Float>();
		mSectionColor = new Array<UInt>();
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
		checkIntersect();
		
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
	
	function checkIntersect()
	{
		var max = mAllLaser.length;
		var cross : Bool = false;
		mNbSection = 0;
		for (i in 0 ... max) {
			var laser = mAllLaser[i];
			if (laser == mNextLaser || laser == mPrevLaser) continue;
			var a : Vec2 = pos;
			var b : Vec2 = mEndPos.clone();
			
			var c : Vec2 = laser.pos.clone();
			var d : Vec2 = laser.getEndPos().clone();
			
			var distAB:Float, cos:Float, sin:Float, newX:Float, ABpos:Float;
			
			if ((a.x == b.x && a.y == b.y) || (c.x == d.x && c.y == d.y)) continue;
		 
			if ( a == c || a == d || b == c || b == d ) continue;
		 
			b.offset( -a.x, -a.y);
			c.offset( -a.x, -a.y);
			d.offset( -a.x, -a.y);
			// a is now considered to be (0,0)
		 
			distAB = b.length();
			cos = b.x / distAB;
			sin = b.y / distAB;
		 
			c = new Vec2(c.x * cos + c.y * sin, c.y * cos - c.x * sin);
			d = new Vec2(d.x * cos + d.y * sin, d.y * cos - d.x * sin);
		 
			if ((c.y < 0 && d.y < 0) || (c.y >= 0 && d.y >= 0)) continue;
		 
			ABpos = d.x + (c.x - d.x) * d.y / (d.y - c.y); // what.
			if (ABpos < 0 || ABpos > distAB) continue;
			
			var px = pos.x + cos * ABpos;
			var py = pos.y + sin * ABpos;
			
			var color = mColor | laser.getColorAt(px, py);
			
			cross = true;
			
			if (mSection.length == mNbSection){
				mSection.push(ABpos);
				mSectionColor.push(color);
			}
			else{
				mSection[mNbSection] = ABpos;
				mSectionColor[mNbSection] = color;
			}
			mNbSection++;
		}
		if (cross) {
			trace(cross);
			var end = mNbSection - 1;
			while (end != 0) {
				for (i in 0 ... end) {
					if (mSection[i] > mSection[i + 1]) {
						var tempSection = mSection[i];
						var tempColor = mSectionColor[i];
						
						mSection[i] = mSection[i + 1];
						mSection[i + 1] = tempSection;
						
						mSectionColor[i] = mSectionColor[i + 1];
						mSectionColor[i + 1] = tempColor;
					}
				}
				end--;
			}
		}
	}
	
	public function getColorAt(x : Float, y : Float) : UInt {
		if (mNbSection == 0)
			return mColor;
		else {
			var distX = x - pos.x;
			var distY = y - pos.y;
			var len = Math.sqrt(distX * distX + distY * distY);
			
			if (len <= mSection[0])
				return mColor;
			
			for (i in 0 ... mNbSection - 1) {
				if (len > mSection[i] && len < mSection[i + 1])
					return mSectionColor[i];
			}
			return mSectionColor[mNbSection -1];
		}
	}
	
	public function getLastColor() : UInt{
		if (mNbSection == 0)
			return mColor;
		else
			return mSectionColor[mNbSection - 1];
	}
	
	function createNextLaser(color : UInt) {
		if (mNextLaser == null){
			mNextLaser = new Laser(mEndPos, mLevel, getLastColor() , mReflectNum + 1, this);
			mLevel.add(mNextLaser);
		}
		
		mNextLaser.pos.x = mEndPos.x;
		mNextLaser.pos.y = mEndPos.y;
		mNextLaser.setDir(mDir.x, mDir.y);
	}
	
	function reflect(from:HitDirection, tileInfo:TileInfo) 
	{
		createNextLaser(mColor);
			
		if (from == HitDirection.BOTTOM && tileInfo.reflectPos == "bottom")
			mNextLaser.setDir(mDir.x, -mDir.y);
		else if (from == HitDirection.LEFT && tileInfo.reflectPos == "left")
			mNextLaser.setDir(-mDir.x, mDir.y);
		else if (from == HitDirection.TOP && tileInfo.reflectPos == "top")
			mNextLaser.setDir(mDir.x, -mDir.y);
		else if (from == HitDirection.RIGHT && tileInfo.reflectPos == "right")
			mNextLaser.setDir(-mDir.x, mDir.y);
		else {
			mNextLaser.destroy();
			mNextLaser = null;
		}
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		mDrawLine.graphics.clear();
		if (mNbSection == 0) {
			var x = dest.x + (mEndPos.x - pos.x); 
			var y = dest.y + (mEndPos.y - pos.y);
			drawLaser(dest.x, dest.y, x, y, mColor);
		}else {
			if (mNbSection == 1) {
				var x = dest.x + mSection[0] * Math.cos(mAngle / 180 * Math.PI);
				var y = dest.y + mSection[0] * Math.sin(mAngle / 180 * Math.PI);
				
				drawLaser(dest.x, dest.y, x, y, mColor);
				drawLaser(x, y, dest.x + (mEndPos.x - pos.x), dest.y + (mEndPos.y - pos.y), mSectionColor[0]);
			}
			else
				for (i in 0 ... mNbSection) {
					
					var x = dest.x + mSection[i] * Math.cos(mAngle / 180 * Math.PI);
					var y = dest.y + mSection[i] * Math.sin(mAngle / 180 * Math.PI);
					
					if (i == 0) {
						drawLaser(dest.x, dest.y, x, y, mColor);
					}
					if (i < mNbSection - 1) {
						var sx = dest.x + mSection[i + 1] * Math.cos(mAngle / 180 * Math.PI);
						var sy = dest.y + mSection[i + 1] * Math.sin(mAngle / 180 * Math.PI);
							
						drawLaser(x, y, sx, sy, mSectionColor[i]);
					}else 
						drawLaser(x, y, dest.x + (mEndPos.x - pos.x), dest.y + (mEndPos.y - pos.y), mSectionColor[i]);
				}
		}
		
		buffer.draw(mDrawLine);
	}
	
	function drawLaser(sx : Float, sy : Float, ex : Float, ey : Float, color : UInt) {
		var radius = Math.random() * 5 + 3;
		drawLaserOut(sx, sy, ex, ey, color);
		drawImpactCircleOut(ex, ey, radius, color);
		drawLaserIn(sx, sy, ex, ey);
		drawImpactCircleIn(ex, ey, radius);
	}
	
	function drawImpactCircleIn(x : Float, y : Float, radius : Float):Void 
	{
		mDrawLine.graphics.lineStyle(0, 0, 0);
		mDrawLine.graphics.beginFill(0xffffff, 0.7);
		mDrawLine.graphics.drawCircle(x, y, radius);
		mDrawLine.graphics.beginFill(0xffffff);
		mDrawLine.graphics.drawCircle(x, y, radius-4);
	}
	
	function drawImpactCircleOut(x : Float, y : Float, radius : Float, color : UInt):Void 
	{
		mDrawLine.graphics.lineStyle(0, 0, 0);
		mDrawLine.graphics.beginFill(color, 0.7);
		mDrawLine.graphics.drawCircle(x, y, radius+3);
	}
	
	function drawLaserOut(startX : Float, startY : Float, endX : Float, endY : Float, color : UInt):Void 
	{
		mDrawLine.graphics.lineStyle(8, color, 0.5);
		mDrawLine.graphics.moveTo(startX,startY);
		mDrawLine.graphics.lineTo(endX, endY);
		
		mDrawLine.graphics.lineStyle(5, color, 0.8);
		mDrawLine.graphics.moveTo(startX,startY);
		mDrawLine.graphics.lineTo(endX, endY);
	}
	
	function drawLaserIn(sx : Float, sy : Float, ex : Float, ey : Float ):Void 
	{
		mDrawLine.graphics.lineStyle(2, 0xffffff, 0.8);
		mDrawLine.graphics.moveTo(sx,sy);
		mDrawLine.graphics.lineTo(ex, ey);
	}
	
	public function getDir() : Vec2 {
		return mDir;
	}
	
	public function getEndPos() : Vec2 {
		return mEndPos;
	}
	
	public function getCol() : UInt {
		return mColor;
	}
	
	override public function destroy() 
	{
		super.destroy();
		mAllLaser.remove(this);
		if (mNextLaser != null)
			mNextLaser.destroy();
	}
	
}