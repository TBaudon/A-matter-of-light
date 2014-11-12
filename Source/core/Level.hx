package core;
import ash.core.Entity;
import ash.core.System;

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
	
	public function getSystems() : Array<System> {
		return mSystems;
	}
	
	public function getEntities() : Array<Entity> {
		return mEntities;
	}
	
	
	
}