package systems;
import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import core.Game;
import nape.geom.Vec2;
import nape.space.Space;
import nape.util.BitmapDebug;
import nodes.PhysicNode;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Thomas BAUDON
 */
class PhysicSystem extends System
{
	
	var mSpace : Space;
	var mPhysicNodeList : NodeList<PhysicNode>;
	
	#if debug
	var mDrawDebug : Bool;
	var mDebugDisplay : BitmapDebug;
	#end

	public function new() 
	{
		super();
		
		mSpace = new Space(Vec2.get(0.0, 980));
		
		#if debug
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		var w = Lib.current.stage.stageWidth;
		var h = Lib.current.stage.stageHeight;
		mDebugDisplay = new BitmapDebug(w, h);
		#end
	}
	
	override public function addToEngine(engine:Engine):Void 
	{
		super.addToEngine(engine);
		
		mPhysicNodeList = engine.getNodeList(PhysicNode);
		
		mPhysicNodeList.nodeAdded.add(onPhysicNodeAdded);
		mPhysicNodeList.nodeRemoved.add(onPhysicNodeRemoved);
	}
	
	override public function removeFromEngine(engine:Engine):Void 
	{
		super.removeFromEngine(engine);
		
		mPhysicNodeList.nodeAdded.remove(onPhysicNodeAdded);
		mPhysicNodeList.nodeRemoved.remove(onPhysicNodeRemoved);
	}
	
	override public function update(time:Float):Void 
	{
		super.update(time);
		
		mSpace.step(time);
		#if debug
		if (mDrawDebug) {
			mDebugDisplay.clear();
			mDebugDisplay.draw(mSpace);
			mDebugDisplay.flush();
		}
		#end
		
		var currentNode = mPhysicNodeList.head;
		while (currentNode != null) {
			
			currentNode.transform.position.x = currentNode.body.position.x;
			currentNode.transform.position.y = currentNode.body.position.y;
			
			currentNode.transform.rotation = currentNode.body.rotation*180/Math.PI;
			
			currentNode = currentNode.next;
		}
	}
	
	#if debug
	function onKeyDown(e :KeyboardEvent) {
		if (e.keyCode == Keyboard.COMMA){ 
			mDrawDebug = !mDrawDebug;
			
			if (mDrawDebug)
				Game.getI().getGameLayer().addChild(mDebugDisplay.display);
			else
				Game.getI().getGameLayer().removeChild(mDebugDisplay.display);
		}
	}
	#end
	
	function onPhysicNodeRemoved(node : PhysicNode) 
	{
		node.body.space = null;
	}
	
	function onPhysicNodeAdded(node : PhysicNode) 
	{
		node.body.space = mSpace;
	}
	
}