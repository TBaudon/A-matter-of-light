package core ;
import geom.Vec2;
import haxe.Json;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.ui.Mouse;
import core.Level.MapData;

/**
 * ...
 * @author Thomas BAUDON
 */

typedef MapLayerData = {
	var x : Int;
	var y : Int;
	var width : Int;
	var height : Int;
	var name : String;
	var type : String;
	var data : Array<Int>;
	var properties : Dynamic;
	var objects : Array<Dynamic>;
}

typedef MapTileSetData = {
	var firstgid : Int;
	var image : String;
	var imagewidth : Int;
	var imageheight : Int;
	var name : String;
	var properties : Dynamic;
	var tilewidth : Int;
	var tileheight : Int;
	var terrains : Array<Dynamic>;
	var tiles : Dynamic;
}
 
typedef MapData = {
	var width : Int;
	var height : Int;
	var tilewidth : Int;
	var tileheight : Int;
	var layers : Array<MapLayerData>;
	var properties : Dynamic;
	var tilesets : Array<MapTileSetData>;
}
 
class Level extends Entity
{
	
	var mLevelPath : String;
	var mTilesets : Array<TileSet>;
	var mMapData : MapData;
	var mMainLayer : TileMapLayer;
	
	var mCollisionMap : Array<Int>;
	
	var mGravity : Vec2;
	
	var mTileCoordinateRep : Vec2;
	
	var mPointer : Pointer;
	
	var mCamera : Camera;
	
	public function new(level : String) 
	{
		super(level);
		
		mLevelPath = "levels/" + level + ".json";
		mCollisionMap = new Array<Int>();
		mGravity = new Vec2(0, 1500);
		mTileCoordinateRep = new Vec2();
		mPointer = new Pointer();
		mCamera = new Camera();
	}
	
	public function load() {
		mMapData = Json.parse(Assets.getText(mLevelPath));
		
		loadTileSets(mMapData);
		loadLayers(mMapData);
		add(mPointer);
	}
	
	public function getTilSets() : Array<TileSet>{
		return mTilesets;
	}
	
	public function getMainLayer() : TileMapLayer {
		return mMainLayer;
	}
	
	public function getCollisionMap() : Array<Int> {
		return mCollisionMap;
	}
	
	public function getGravity() 
	{
		return mGravity;
	}
	
	public function getTile(px : Int, py : Int) : Int {
		return mMainLayer.getData()[px + py * mMapData.width];
	}
	
	public function getTileAt(px : Float, py : Float) : Int {
		px = Std.int(px);
		py = Std.int(py);
		
		var w = mMapData.tilewidth;
		var h = mMapData.tileheight;
		var x : Int = Math.floor(px / w);
		var y : Int = Math.floor(py / h);
		var i : Int = y * mMapData.width + x;
		return mCollisionMap[i];
	}
	
	public function getTileCoordinate(x : Float, y : Float) : Vec2 {
		x = Std.int(x);
		y = Std.int(y);
		mTileCoordinateRep.x = Math.floor(x / mMapData.tilewidth);
		mTileCoordinateRep.y = Math.floor(y / mMapData.tileheight);
		return mTileCoordinateRep;
	}
	
	public function getTileWidth() 
	{
		return mMapData.tilewidth;
	}
	
	public function getTileHeight() 
	{
		return mMapData.tileheight;
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		mCamera.update(delta);
		pos.x = -mCamera.pos.x;
		pos.y = -mCamera.pos.y;
		
		var stage = Lib.current.stage;
		mPointer.pos.set(Std.int(stage.mouseX / 2), Std.int(stage.mouseY / 2));
		Mouse.hide();
	}
	
	function loadTileSets(data:MapData) 
	{
		mTilesets = new Array<TileSet>();
		for (tileset in data.tilesets)
			mTilesets.push(new TileSet(tileset));
	}
	
	function loadLayers(data : MapData):Void 
	{
		for (layer in data.layers) 
			switch (layer.type) {
				case "tilelayer" :
					loadTileMapLayer(layer);
				case "objectgroup" :
					loadObjectLayer(layer);
				default :
					trace("unknown layer type");
			}
		if (mMainLayer == null)
			throw "No main layer";
		else
			makeCollisionMap();
	}
	
	function makeCollisionMap() 
	{
		for (tile in mMainLayer.getData()) {
			var terrain : Array<Int> = null;
			for (tileset in mTilesets) {
				terrain = tileset.getTileTerrain(tile);
				if (terrain != null)
					break;
			}
			if (terrain == null)
				mCollisionMap.push(0);
			else {
				var mask : Int = 0;
				for (i in 0 ... terrain.length){
					if (terrain[i] != -1)
						mask = mask | cast Math.pow(2, i);
				}
				mCollisionMap.push(mask);
			}
		}
	}
	
	function loadObjectLayer(layer:MapLayerData) 
	{
		var objects : Array<Dynamic> = layer.objects;
		for (object in objects) {
			var objectClass = Type.resolveClass(object.type);
			var instance : Entity = Type.createInstance(objectClass, [this]);
			add(instance);
			instance.pos.set(object.x, object.y);
			if (Reflect.hasField(object.properties, "hasFocus"))
				mCamera.setTarget(instance);
		}
	}
	
	function loadTileMapLayer(layer:MapLayerData) 
	{
		var tileMapLayer = new TileMapLayer(this, mMapData.tilewidth, mMapData.tileheight, layer);
		
		add(tileMapLayer);
		if (tileMapLayer.name == "main")
			mMainLayer = tileMapLayer;
	}
	
	public function castRay( p1Original:Vec2, p2Original:Vec2, tileSize:Int = 16 ):Vec2
	{
		//INITIALISE//////////////////////////////////////////

		// normalise the points
		var p1:Vec2 = new Vec2( p1Original.x / tileSize, p1Original.y / tileSize);
		var p2:Vec2 = new Vec2( p2Original.x / tileSize, p2Original.y / tileSize);
	
		if ( Std.int( p1.x ) == Std.int( p2.x ) && Std.int( p1.y ) == Std.int( p2.y ) ) {
			//since it doesn't cross any boundaries, there can't be a collision
			return null;
		}
		
		//find out which direction to step, on each axis
		var stepX:Int = ( p2.x > p1.x ) ? 1 : -1;  
		var stepY:Int = ( p2.y > p1.y ) ? 1 : -1;

		var rayDirection:Vec2= new Vec2( p2.x - p1.x, p2.y - p1.y );

		//find out how far to move on each axis for every whole integer step on the other
		var ratioX:Float= rayDirection.x / rayDirection.y;
		var ratioY:Float = rayDirection.y / rayDirection.x;

		var deltaY:Float= p2.x - p1.x;
		var deltaX:Float = p2.y - p1.y;
		//faster than Math.abs()...
		deltaX = deltaX < 0 ? -deltaX : deltaX;
		deltaY = deltaY < 0 ? -deltaY : deltaY;

		//initialise the integer test coordinates with the coordinates of the starting tile, in tile space ( integer )
		//Note: using noralised version of p1
		var testX:Int = Std.int(p1.x); 
		var testY:Int = Std.int(p1.y);

		//initialise the non-integer step, by advancing to the next tile boundary / ( whole integer of opposing axis )
		//if moving in positive direction, move to end of curent tile, otherwise the beginning
		var maxX:Float = deltaX * ( ( stepX > 0 ) ? ( 1.0 - (p1.x % 1) ) : (p1.x % 1) ); 
		var maxY:Float = deltaY * ( ( stepY > 0 ) ? ( 1.0 - (p1.y % 1) ) : (p1.y % 1) );

		var endTileX : Int = Std.int(p2.x);
		var endTileY : Int = Std.int(p2.y);
		
		//TRAVERSE//////////////////////////////////////////

		var hit:Bool;
		var collisionPoint:Vec2= new Vec2();
		
		while( testX != endTileX || testY != endTileY ) {
			
			if (  maxX < maxY ) {
			
				maxX += deltaX;
				testX += stepX;
				
				if ( getTile( testX, testY ) == 1 ) {
					collisionPoint.x = testX;
					if ( stepX < 0 ) { collisionPoint.x += 1.0; //add one if going left
						trace("par la droite");
					}else { trace("par la gauche");}
					collisionPoint.y = p1.y + ratioY * ( collisionPoint.x - p1.x);	
					collisionPoint.x *= tileSize;//scale up
					collisionPoint.y *= tileSize;
					return collisionPoint;
				}
			
			} else {
				
				maxY += deltaY;
				testY += stepY;

				if ( getTile( testX, testY ) == 1 ) {
					collisionPoint.y = testY;
					if ( stepY < 0 ) collisionPoint.y += 1.0; //add one if going up
					collisionPoint.x = p1.x + ratioX * ( collisionPoint.y - p1.y);
					collisionPoint.x *= tileSize;//scale up
					collisionPoint.y *= tileSize;
					return collisionPoint;
				}
			}
	
		}
		
		//no intersection found, just return end point:
		return null;
	}
	
	public function getCamera() : Camera {
		return mCamera;
	}
}