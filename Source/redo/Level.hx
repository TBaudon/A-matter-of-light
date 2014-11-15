package redo;
import haxe.Json;
import openfl.Assets;
import redo.Level.MapData;

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

	public function new(level : String) 
	{
		super(level);
		
		mLevelPath = "levels/" + level + ".json";
	}
	
	public function load() {
		mMapData = Json.parse(Assets.getText(mLevelPath));
		
		loadTileSets(mMapData);
		loadLayers(mMapData);
	}
	
	public function getTilSets() : Array<TileSet>{
		return mTilesets;
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
	}
	
	function loadObjectLayer(layer:MapLayerData) 
	{
		
	}
	
	function loadTileMapLayer(layer:MapLayerData) 
	{
		var tileMapLayer = new TileMapLayer(this, mMapData.tilewidth, mMapData.tileheight, layer);
		add(tileMapLayer);
	}
}