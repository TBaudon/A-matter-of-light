package entities;
import core.Actor;

/**
 * ...
 * @author Thomas BAUDON
 */
class Mecanism extends Actor
{
	
	var mConnectedInterruptor : Array<Interruptor>;
	var mInterruptorToLoad : Array<String>;
	var mActive : Bool;
	var mWasActive : Bool;
	var mInterruptorLoaded : Bool;
	var mDefaultState : Bool;
	var mNo : Bool;

	public function new(sheet : String) 
	{
		super(sheet);
		mInterruptorToLoad = new Array<String>();
		mConnectedInterruptor = new Array<Interruptor>();
		mInterruptorLoaded = false;
		mWasActive = false;
		mDefaultState = true;
	}
	
	public function addInterruptor(name : String) {
		mInterruptorToLoad.push(name);
	}
	
	public function loadInterruptor() {
		for (interruptor in Actor.AllActors) 
		{
			if(mInterruptorToLoad.indexOf(interruptor.name) != -1){
				mConnectedInterruptor.push(cast interruptor);
			}
		}
		
		mInterruptorLoaded = true;
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		
		if (!mInterruptorLoaded)
			loadInterruptor();
		
		mActive = true;
		
		if (mConnectedInterruptor.length == 0)
			mActive = mDefaultState;
		
		for (interruptor in mConnectedInterruptor) {
			if (!interruptor.isActive()) {
				mActive = false;
				break;
			}
		}
		
		if (mNo) mActive = !mActive;
		
		if (!mWasActive && mActive) 
			activate();
		else if (mWasActive && !mActive)
			deactivate();
			
		mWasActive = mActive;
	}
	
	function activate() {
		mLevel.getCamera().shake(2, 200);
	}
	
	function deactivate() {
	}
	
	override public function setProperties(props:Dynamic) 
	{
		super.setProperties(props);
		if(props.interruptors != null)
			mInterruptorToLoad = cast(props.interruptors, String).split(',');
		mNo = props.no;
	}
	
}