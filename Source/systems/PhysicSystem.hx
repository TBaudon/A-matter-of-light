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
	
	var mGravity : Vec2;
	
	public function new() 
	{
		super();
		
		mGravity = new Vec2(0.0, 10);
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
			
			updateNodePhysics(node, time);
			
			node.transform.position.x = node.body.position.x;
			node.transform.position.y = node.body.position.y;
			
			node = node.next;
		}
	}
	
	function updateNodePhysics(node:PhysicNode, delta : Float) 
	{
		var body = node.body;
		
		if (body.type != BodyType.STATIC) {
			body.velocity.add(Vec2.Mul(mGravity, delta));
			body.position.add(body.velocity);
			
			if (body.position.y + (1 - body.origin.y) * body.h >= 240) {
				body.velocity.y = 0;
				body.position.y = 240 - (1 - body.origin.y) * body.h;
			}
		}
	}
	
	function onPhysicNodeRemoved(node : PhysicNode) 
	{
		
	}
	
	function onPhysicNodeAdded(node : PhysicNode) 
	{
		
	}
	
}