package core;
import ash.core.Entity;
import ash.core.System;
import components.TileMap;
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
		var tileSize = data.tilesets[0].tilewidth;
		var layers : Array<Dynamic> = cast data.layers;
		
		var tileSetPath : String = data.tilesets[0].image;
		tileSetPath = Path.removeTrailingSlashes(tileSetPath.toString());
		tileSetPath = Path.normalize(tileSetPath.toString());
		
		var tileSet = Assets.getBitmapData(tileSetPath);
		
		for (i in 0 ... nbLayer) {
			if (layers[i].type == "tilelayer"){
				var map = new Entity("map_layer" + i);
				map.add(new View());
				map.add(new Transform());
				var tileMap = new TileMap(w, h, tileSize, layers[i].data);
				tileMap.tileSet = tileSet;
				map.add(tileMap);
				add(map);
			}
		}
	}
	
	public function getSystems() : Array<System> {
		return mSystems;
	}
	
	public function getEntities() : Array<Entity> {
		return mEntities;
	}
	
	
	
}