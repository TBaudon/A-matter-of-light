package systems;
import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import components.Body;
import core.Game;
import geom.Vec2;
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
	
	var mPhysicNodeList:NodeList<PhysicNode>;
	
	public function new() 
	{
		super();
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
		
		var node : PhysicNode = mPhysicNodeList.head;
		
		while (node != null) {
			node.transform.position.x = node.body.position.x;
			node.transform.position.y = node.body.position.y;
			
			node = node.next;
		}
	}
	
	function onPhysicNodeRemoved(node : PhysicNode) 
	{
		
	}
	
	function onPhysicNodeAdded(node : PhysicNode) 
	{
		node.body.position.x = node.transform.position.x;
		node.body.position.y = node.transform.position.y;
	}
	
}