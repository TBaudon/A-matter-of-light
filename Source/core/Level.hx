package core;
import ash.core.Entity;
import ash.core.System;
import components.tileMap.TileMap;
import components.tileMap.TileMapCollisionMask;
import components.tileMap.TileMapObject;
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
	
	public var onLevelEnd : String -> Void;
	
	public function new() 
	{
		mEntities = new Array<Entity>();
		
		onLevelEnd = function (nextLevel : String) { };
	}
	
	function add(ent : Entity) {
		mEntities.push(ent);
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
		
		if (Reflect.hasField(layer,"properties") && Reflect.hasField(layer.properties,"collisionMask")) 
			map.add(new TileMapCollisionMask());
		else {
			map.add(new View());
			map.add(new Transform());
		}
		
		var tileMap = new TileMap(w, h, tileSize, mapData);
		tileMap.tileSet = tileSet;
		map.add(tileMap);
		add(map);
	}
	
	public function getEntities() : Array<Entity> {
		return mEntities;
	}
}