package entities ;
import core.Entity;
import core.Level;
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

	public function new(level : Level) 
	{
		super();
		mLevel = level;
		mAngle = 0;
		mFiring = false;
		mDir = new Vec2();
		mDrawLine = new Shape();
	}
	
	public function setAngle(angle : Float) {
		mAngle = angle / Math.PI * 180;
	}
	
	public function setEndPos(vec : Vec2) {
		mEndPos = vec;
		mDir.set(mEndPos.x - pos.x, mEndPos.y - pos.y);
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		if (mEndPos == null) return;
		
		mStartX = cast pos.x / mLevel.getTileWidth();
		mStartY = cast pos.y / mLevel.getTileHeight();
		
		mEndX = cast mEndPos.x / mLevel.getTileWidth();
		if (mEndX < 0) mEndX = 0;
		/*if (mEndX > mLevel.getMainLayer().getWidth() - 1)
			mEndX = mLevel.getMainLayer().getWidth() - 1;*/
		
		mEndY = cast mEndPos.y / mLevel.getTileHeight();
		if (mEndY < 0) mEndY = 0;
		/*if (mEndY > mLevel.getMainLayer().getHeight() - 1)
			mEndY = mLevel.getMainLayer().getHeight() - 1;*/
			
		trace(mEndX, mEndY);
		var ar = Utils.getLine(mStartX, mStartY, mEndX, mEndY);
		mTile = ar;
		var closestObstacleX = mEndX;
		var closestObstacleY = mEndY;
		
		var xDist = mEndX - mStartX;
		var yDist = mEndY - mStartY;
		var minDist = Math.sqrt(xDist * xDist + yDist * yDist);
		
		for (tileCoord in ar) {	
			var tile = mLevel.getTileAt(tileCoord.x * mLevel.getTileWidth(), tileCoord.y * mLevel.getTileHeight()) ;
			if (tile != 0) {
				xDist = tileCoord.x - mStartX;
				yDist = tileCoord.y - mStartY;
				var dist = Math.sqrt(xDist * xDist + yDist * yDist);
				if (dist < minDist) {
					minDist = dist;
					mEndX = tileCoord.x;
					mEndY = tileCoord.y;
				}
			}
		}
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		
		mDrawLine.graphics.clear();
		mDrawLine.graphics.lineStyle(12, 0xff0000, 0.8);
		mDrawLine.graphics.moveTo(dest.x,dest.y);
		mDrawLine.graphics.lineTo(dest.x + mDir.x, dest.y + mDir.y);
		mDrawLine.graphics.lineStyle(8, 0xffffff, 0.4);
		mDrawLine.graphics.moveTo(dest.x,dest.y);
		mDrawLine.graphics.lineTo(dest.x + mDir.x, dest.y + mDir.y);
		mDrawLine.graphics.lineStyle(4, 0xffffff, 0.8);
		mDrawLine.graphics.moveTo(dest.x,dest.y);
		mDrawLine.graphics.lineTo(dest.x + mDir.x, dest.y + mDir.y);
		mDrawLine.filters = [new GlowFilter(0xff0000)];
		buffer.draw(mDrawLine);
	}
	
}