package redo;
import haxe.io.Path;
import openfl.Assets;
import openfl.display.BitmapData;
import redo.Level.MapTileSetData;

/**
 * ...
 * @author Thomas BAUDON
 */

typedef TileStamp = {
	var bitmap : BitmapData;
	var x : Int;
	var y : Int;
	var w : Int;
	var h : Int;
}
 
class TileSet
{
	
	var mBitampData : BitmapData;
	var mFirstGid : Int;
	var mLastGid : Int;
	
	var mTileWidth : Int;
	var mTileHeight : Int;
	
	var mImageWidth : Int;
	var mImageHeight : Int;
	var mNbCol:Int;
	var mNbLine:Int;
	
	var mStamp : TileStamp;
	
	var mData : MapTileSetData;

	public function new(data : MapTileSetData) 
	{
		var tileSetPath : String = data.image;
		tileSetPath = Path.removeTrailingSlashes(tileSetPath.toString());
		tileSetPath = Path.normalize(tileSetPath.toString());
		mBitampData = Assets.getBitmapData(tileSetPath);
		
		mTileWidth = data.tilewidth;
		mTileHeight = data.tileheight;
		mImageWidth = data.imagewidth;
		mImageHeight = data.imageheight;
		
		mNbCol = Std.int(mImageWidth / mTileWidth);
		mNbLine = Std.int(mImageHeight / mTileHeight);
		
		var nbTiles = mNbCol * mNbLine;
		
		mFirstGid = data.firstgid;
		mLastGid = mFirstGid + nbTiles - 1;
		
		mData = data;
		
		mStamp = {
			bitmap : mBitampData,
			x : 0,
			y : 0,
			w : mTileWidth,
			h : mTileHeight
		};
	}
	
	public function getStamp(tileId : Int) : TileStamp {
		if (tileId >= mFirstGid && tileId <= mLastGid) {
			tileId-= mFirstGid;
			
			var x = tileId % mNbCol;
			var y = Std.int(tileId / mNbCol);
			
			mStamp.x = x * mTileWidth;
			mStamp.y = y * mTileHeight;
			return mStamp;
		}else
			return null;
	}
	
	public function getTileTerrain(tileId : Int) : Array<Int> {
		if (tileId >= mFirstGid && tileId <= mLastGid) {
			tileId -= mFirstGid;
			
			if (Reflect.hasField(mData, "tiles")) {
				var tiles = mData.tiles;
				if (Reflect.hasField(tiles, "" + tileId))
					return Reflect.field(tiles, "" + tileId).terrain;
			}
			return [-1,-1,-1,-1];
		}else
			return null;
	}
	
}