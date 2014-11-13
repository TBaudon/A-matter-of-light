package systems;
import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import nape.geom.Vec2;
import nodes.PlayerControlerNode;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Thomas BAUDON
 */
class PlayerControlSystem extends System
{
	
	var mControlerNodeList : NodeList<PlayerControlerNode>;

	public function new() 
	{
		super();
	}
	
	override public function addToEngine(engine:Engine):Void 
	{
		super.addToEngine(engine);
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
		mControlerNodeList = engine.getNodeList(PlayerControlerNode);
	}
	
	override public function removeFromEngine(engine:Engine):Void 
	{
		super.removeFromEngine(engine);
		
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	override public function update(time:Float):Void 
	{
		super.update(time);
		
		var node = mControlerNodeList.head;
		while (node != null) {
			
			node.body.applyImpulse(Vec2.weak(node.controler.xAxis, 0).muleq(1000*time));
			
			if (node.controler.jumpDown)
				node.body.applyImpulse(Vec2.weak(0, -10000*time));
			
			node = node.next;
		}
	}
	
	function onKeyUp(e:KeyboardEvent):Void 
	{
		var node = mControlerNodeList.head;
		while (node != null) {
			
			if (e.keyCode == Keyboard.D) 
				node.controler.xAxis = 0;
			if (e.keyCode == Keyboard.Q)
				node.controler.xAxis = 0;
			if (e.keyCode == Keyboard.SPACE)
				node.controler.jumpDown = false;
			if (e.keyCode == Keyboard.Z)
				node.controler.actionDown = false;
			
			node = node.next;
		}
	}
	
	function onKeyDown(e:KeyboardEvent):Void 
	{
		var node = mControlerNodeList.head;
		while (node != null) {
			if (e.keyCode == Keyboard.D) 
				node.controler.xAxis = 1.0;
			if (e.keyCode == Keyboard.Q)
				node.controler.xAxis = -1.0;
			if (e.keyCode == Keyboard.SPACE)
				node.controler.jumpDown = true;
			if (e.keyCode == Keyboard.Z)
				node.controler.actionDown = true;
			
			node = node.next;
		}
	}
	
}