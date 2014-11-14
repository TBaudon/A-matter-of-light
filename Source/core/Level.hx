package core;
import ash.core.Entity;
import ash.core.System;
import components.TileMap;
import components.TileMapObject;
import components.Transform;
import components.View;
import haxe.io.Path;
import haxe.Json;
import openfl.Assets;

/**
 * ...
 * @author Thomas BAUDON
 */
class Level
{

	var mEntities : Array<Entity>;
	var mSystems : Array<System>;
	
	public var onLevelEnd : String -> Void;
	
	public function new() 
	{
		mSystems = new Array<System>();
		mEntities = new Array<Entity>();
		
		onLevelEnd = function (nextLevel : String) { };
	}
	
	function add(ent : Entity) {
		mEntities.push(ent);
	}
	
	function addSystem(sys : System) {
		mSystems.push(sys);
	}
	
	public function load(level : String) {
		var mapJson = Assets.getText("levels/" + level + ".json");
		var data = Json.parse(mapJson);
		
		var nbLayer = data.layers.length;
		
		var w = data.width;
		var h = data.height;
		
		var layers : Array<Dynamic> = cast data.layers;
		
		for (i in 0 ... nbLayer) {
			var layer = layers[i];
			switch(layer.type) {
				case "tilelayer" :
					loadTileMap(layer,w,h,data,layers[i].data);
				case "objectgroup" :
					loadObjects(layer);
				default :
					trace("Unknown layer type");
			}
			if (layers[i].type == "tilelayer"){
				
			}
		}
	}
	
	function loadObjects(layer : Dynamic) 
	{
		var objects : Array<Dynamic> = layer.objects;
		
		for (object in objects) {
			var entityClass : Class<Dynamic> = Type.resolveClass(object.type);
			var entity : Entity = Type.createInstance(entityClass, []);
			entity.name = object.name;
			
			if (entity.has(Transform))
			{
				var transform : Transform = entity.get(Transform);
				transform.position.x = object.x;
				transform.position.y = object.y;
			}
			
			entity.add(new TileMapObject());
			
			add(entity);
		}
	}
	
	function loadTileMap(layer : Dynamic, w : Int, h : Int, data : Dynamic, mapData : Array<Int>) 
	{
		var tileSize = data.tilesets[0].tilewidth;
		
		var tileSetPath : String = data.tilesets[0].image;
		tileSetPath = Path.removeTrailingSlashes(tileSetPath.toString());
		tileSetPath = Path.normalize(tileSetPath.toString());
		
		var tileSet = Assets.getBitmapData(tileSetPath);
		
		var map = new Entity(layer.name);
		map.add(new View());
		map.add(new Transform());
		var tileMap = new TileMap(w, h, tileSize, mapData);
		tileMap.tileSet = tileSet;
		map.add(tileMap);
		add(map);
	}
	
	public function getSystems() : Array<System> {
		return mSystems;
	}
	
	public function getEntities() : Array<Entity> {
		return mEntities;
	}
	
	
	
}