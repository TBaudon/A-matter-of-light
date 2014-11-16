package core ;
import geom.Vec2;
import haxe.Json;
import openfl.Assets;
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
	
	public function new(level : String) 
	{
		super(level);
		
		mLevelPath = "levels/" + level + ".json";
		mCollisionMap = new Array<Int>();
		mGravity = new Vec2(0, 25);
		mTileCoordinateRep = new Vec2();
		mPointer = new Pointer();
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
		var hero = new Hero(this);
		hero.pos.x = 150;
		hero.pos.y = 20;
		add(hero);
	}
	
	function loadTileMapLayer(layer:MapLayerData) 
	{
		var tileMapLayer = new TileMapLayer(this, mMapData.tilewidth, mMapData.tileheight, layer);
		add(tileMapLayer);
		if (tileMapLayer.name == "main")
			mMainLayer = tileMapLayer;
	}
}