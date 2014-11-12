package systems;
import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import nape.geom.Vec2;
import nape.space.Space;
import nodes.PhysicNode;

/**
 * ...
 * @author Thomas BAUDON
 */
class PhysicSystem extends System
{
	
	var mSpace : Space;
	var mPhysicNodeList : NodeList<PhysicNode>;

	public function new() 
	{
		super();
		
		mSpace = new Space(Vec2.get(0.0, 980));
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
		
		var currentNode = mPhysicNodeList.head;
		while (currentNode != null) {
			
			currentNode.transform.position.x = currentNode.body.position.x;
			currentNode.transform.position.y = currentNode.body.position.y;
			
			currentNode.transform.rotation = currentNode.body.rotation;
			
			currentNode = currentNode.next;
		}
	}
	
	function onPhysicNodeRemoved(node : PhysicNode) 
	{
		node.body.space = null;
	}
	
	function onPhysicNodeAdded(node : PhysicNode) 
	{
		node.body.space = mSpace;
	}
	
}