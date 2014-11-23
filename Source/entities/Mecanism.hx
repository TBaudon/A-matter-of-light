package entities;
import core.Actor;

/**
 * ...
 * @author Thomas BAUDON
 */
class Mecanism extends Actor
{
	
	var mConnectedInterruptor : Array<Interruptor>;
	var mActive : Bool;

	public function new(sheet : String) 
	{
		super(sheet);
		
		mConnectedInterruptor = new Array<Interruptor>();
	}
	
	public function addInterruptor(name : String) {
		for (interruptor in Actor.AllActors) {
			if (interruptor.name == name)
				mConnectedInterruptor.push(cast interruptor);
		}
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		mActive = true;
		
		for (interruptor in mConnectedInterruptor) {
			if (!interruptor.isActive()) {
				mActive = false;
				break;
			}
		}
	}
	
}