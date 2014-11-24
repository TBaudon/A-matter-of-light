package entities;
import core.Actor;
import geom.Vec2;

/**
 * ...
 * @author Thomas BAUDON
 */
class EntitiesSpawner extends Mecanism
{
	
	var mEntitieToSpawn : Class<Dynamic>;
	var mDirection : String;
	var mSpawnSpeed : Float;

	public function new() 
	{
		super(null);
		
		mSolid = false;
		mStatic = true;
	}
	
	override function activate() 
	{
		super.activate();
		
		var entity : Actor = Type.createInstance(mEntitieToSpawn, []);
		entity.pos.copy(pos);
		entity.setLevel(mLevel);
		mLevel.add(entity);
		
		switch(mDirection) {
			case "Up" :
				entity.vel.y = -mSpawnSpeed;
			case "Right" :
				entity.vel.x = mSpawnSpeed;
			case "Down" : 
				entity.vel.y = mSpawnSpeed;
			case "Left" :
				entity.vel.x = -mSpawnSpeed;
		}
	}
	
	override public function setProperties(props:Dynamic) 
	{
		super.setProperties(props);
		
		mEntitieToSpawn = Type.resolveClass(props.entity);
		mInterruptorToLoad = cast(props.interruptors, String).split(',');
		mDirection = props.direction;
		mSpawnSpeed = props.spawnSpeed;
	}
	
}