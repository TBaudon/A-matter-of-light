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
	
	var mSpawner :Actor;
	
	public static var All : Array<Laser>;
	
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
		
		All.push(this);
		
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
	
	public function setSpawner(spawner: Actor) {
		mSpawner = spawner;
	}
	
	public function setDir(x : Float, y : Float) {
		mDir.set(x, y);
		mAngle = Math.atan2(y, x) / Math.PI * 180;
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		mImpact = false;
		
		var end : RaycastData = mLevel.castRay(pos.x, pos.y, pos.x + mDir.x, pos.y + mDir.y);
		if (mNextLaser != null)
			mNextLaser.setColor(getLastColor());
		
		if (end != null) {
			mEndPos = end.hitPos;
			var hittedActor = checkActorsCollision(delta);
			if (hittedActor != null)
				end.object = hittedActor;
			mImpact = true;
			
			if (Std.is(end.object, TileInfo)) {
				var tileInfo : TileInfo = end.object;
				if (tileInfo.reflect && mReflectNum < MAX_REFLECT)
					reflect(end.from, tileInfo);
				else if (mNextLaser != null){
					mNextLaser.destroy();
					mNextLaser = null;
				}
			}else if (mNextLaser != null){
				mNextLaser.destroy();
				mNextLaser = null;
			}
		} 
	}
	
	public function checkIntersect()
	{
		var max = All.length;
		var cross : Bool = false;
		mNbSection = 0;
		for (i in 0 ... max) {
			var laser = All[i];
			if (laser == mNextLaser || laser == mPrevLaser || laser == this) continue;
			
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
			
			//if (laser.getColorAt(px, py) == getColorAt(px, py)) continue;
			
			var color = getColorAt(px, py) | laser.getColorAt(px, py);
			if (laser.getColorAt(px, py) == 0xffffff)
				color = getColorAt(px, py);
			
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
	
	public function getAngle() : Float {
		return mAngle / 180 * Math.PI;
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
				if (len > mSection[i] && len <= mSection[i + 1])
					return mSectionColor[i];
			}
			return mSectionColor[mNbSection -1];
		}
	}
	
	public function getLastColor() : UInt{
		if (mNbSection == 0){
			return mColor;
		}
		else
			return mSectionColor[mNbSection - 1];
	}
	
	public function setColor(color : UInt) {
		mColor = color;
	}
	
	function createNextLaser(color : UInt) {
		if (mNextLaser == null){
			mNextLaser = new Laser(mEndPos, mLevel, getLastColor() , mReflectNum + 1, this);
			mLevel.add(mNextLaser);
		}
		
		mNextLaser.pos.x = mEndPos.x;
		mNextLaser.pos.y = mEndPos.y;
	}
	
	function reflect(from:HitDirection, tileInfo:TileInfo) 
	{
		createNextLaser(getLastColor());
			
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
		All.remove(this);
		if (mNextLaser != null)
			mNextLaser.destroy();
	}
	
	function checkActorsCollision(delta : Float) : Actor{
		var hittedActor : Actor = null;
		for (actor in Actor.AllActors) {		
			if (!actor.isSolid() || actor == mSpawner) continue;
			var collisions : Array<Vec2> = rayBoxIntersect(pos, mEndPos, actor.pos, Vec2.Add(actor.pos, actor.getDim()));
			if (collisions != null && collisions[0] != null) {
				
				if (collisions[1] == null) {
					mEndPos = collisions[0];
					continue;
				}
				
				var a = Vec2.Dist(pos, collisions[0]);
				var b = Vec2.Dist(pos, collisions[1]);
				
				if (a > b)
					mEndPos = collisions[1];
				else
					mEndPos = collisions[0];
					
				hittedActor = actor;
			}
		}
		if(hittedActor != null )
			hittedActor.onLaserHit(this, delta );
			
		return hittedActor;
	}
	
	public static function rayBoxIntersect(r1:Vec2, r2:Vec2, box1:Vec2, box2:Vec2):Array<Vec2> {
			
		// lower values of bounding box
		var b1:Vec2 = new Vec2();
		// higher values of bounding box
		var b2:Vec2 = new Vec2();
		
		b1.x = Math.min(box1.x, box2.x);
		b1.y = Math.min(box1.y, box2.y);
		b2.x = Math.max(box1.x, box2.x);
		b2.y = Math.max(box1.y, box2.y);
		
		if (b2.x < Math.min(r1.x, r2.x) || b1.x > Math.max(r1.x, r2.x)) return null;
		if (b2.y < Math.min(r1.y, r2.y) || b1.y > Math.max(r1.y, r2.y)) return null;
		
		var arr:Array<Vec2> = [];
		var tnear:Float;	// near value on plane
		var tfar:Float;	// far value on plane
		
		tnear = Math.max((b1.x - r1.x) / (r2.x - r1.x), (b1.y - r1.y) / (r2.y - r1.y));
		tfar = Math.min((b2.x - r1.x) / (r2.x - r1.x), (b2.y - r1.y) / (r2.y - r1.y));
		if (tnear < tfar) {
			if (tnear >=0 && tnear <= 1) arr[0] = Vec2.interpolate(r2, r1, tnear);
			if (tfar >= 0 && tfar <= 1) arr[1] = Vec2.interpolate(r2, r1, tfar);
			return arr;
		}
		
		tnear = Math.min((b1.x - r1.x) / (r2.x - r1.x), (b1.y - r1.y) / (r2.y - r1.y));
		tfar = Math.max((b2.x - r1.x) / (r2.x - r1.x), (b2.y - r1.y) / (r2.y - r1.y));
		if (tnear > tfar) {
			if (tnear >=0 && tnear <= 1) arr[0] = Vec2.interpolate(r2, r1, tnear);
			if (tfar >= 0 && tfar <= 1) arr[1] = Vec2.interpolate(r2, r1, tfar);
			return arr;
		}
		
		tnear = Math.min((b2.x - r1.x) / (r2.x - r1.x), (b1.y - r1.y) / (r2.y - r1.y));
		tfar = Math.max((b1.x - r1.x) / (r2.x - r1.x), (b2.y - r1.y) / (r2.y - r1.y));
		if (tnear > tfar) {
			if (tnear >=0 && tnear <= 1) arr[0] = Vec2.interpolate(r2, r1, tnear);
			if (tfar >= 0 && tfar <= 1) arr[1] = Vec2.interpolate(r2, r1, tfar);
			return arr;
		}
		
		tnear = Math.max((b2.x - r1.x) / (r2.x - r1.x), (b1.y - r1.y) / (r2.y - r1.y));
		tfar = Math.min((b1.x - r1.x) / (r2.x - r1.x), (b2.y - r1.y) / (r2.y - r1.y));
		if (tnear < tfar) {
			if (tnear >=0 && tnear <= 1) arr[0] = Vec2.interpolate(r2, r1, tnear);
			if (tfar >= 0 && tfar <= 1) arr[1] = Vec2.interpolate(r2, r1, tfar);
			return arr;
		}
		
		return null;
	}
	
}