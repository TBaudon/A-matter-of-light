package redo;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import redo.Level.MapLayerData;
import redo.TileSet.TileStamp;

/**
 * ...
 * @author Thomas BAUDON
 */
class TileMapLayer extends Entity
{
	
	var mLevel : Level;
	var mData : Array<Int>;
	
	var mNbCol : Int;
	var mNbLine : Int;
	
	var mTileWidth : Int;
	var mTileHeight : Int;
	
	var mScrollWidth : Int;
	var mScrollHeight : Int;
	
	var mRectStamp : Rectangle;
	var mPointStamp : Point;
	
	var mName : String;

	public function new(level : Level, tileWidth : Int, tileHeight : Int, layerData : MapLayerData) 
	{
		super();
		
		mRectStamp = new Rectangle();
		mPointStamp = new Point();
		
		mLevel = level;
		mData = layerData.data;
		mNbCol = layerData.width;
		mNbLine = layerData.height;
		
		mTileWidth = tileWidth;
		mTileHeight = tileHeight;
		
		mName = layerData.name;
	}
	
	override function draw(buffer : BitmapData) 
	{
		super.draw(buffer);
		
		mScrollWidth = Std.int(buffer.width / mTileWidth)+1;
		mScrollHeight = Std.int(buffer.height / mTileHeight)+1;
		
		var startI : Int = Std.int(-pos.y / mTileHeight);
		var startJ : Int = Std.int(-pos.x / mTileWidth);
		
		var endI : Int;
		var endJ : Int;
		
		if (startI + mScrollHeight < mNbLine)
			endI = startI + mScrollHeight;
		else
			endI = mNbLine;
			
		if (startJ + mScrollWidth < mNbCol)
			endJ = startJ + mScrollWidth;
		else
			endJ = mNbCol;
			
		for (i in startI ... endI) 
			for (j in startJ ... endJ) {
				var tileId = mData[i * mNbCol + j];
				if (tileId == 0) continue;
				
				var stamp : TileStamp = getStamp(tileId);
				if (stamp != null) {
					mRectStamp.x = stamp.x;
					mRectStamp.y = stamp.y;
					mRectStamp.width = stamp.w;
					mRectStamp.height = stamp.h;
					
					var destX = j * mTileWidth;
					destX -= cast -pos.x;
					var destY = i * mTileHeight;
					destY -= cast -pos.y;
					
					mPointStamp.x = destX;
					mPointStamp.y = destY;
					buffer.copyPixels(stamp.bitmap, mRectStamp, mPointStamp);
				}
			}
	}
	
	function getStamp(tile : Int) : TileStamp {
		for (tileSet in mLevel.getTilSets()) {
			var stamp = tileSet.getStamp(tile);
			if (stamp != null) return stamp;
		}
		return null;
	}
	
}