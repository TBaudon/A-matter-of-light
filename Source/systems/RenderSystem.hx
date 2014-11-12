package systems;
import ash.tools.ListIteratingSystem;
import core.Game;
import nodes.RenderNode;
import openfl.display.Sprite;

/**
 * ...
 * @author Thomas BAUDON
 */
class RenderSystem extends ListIteratingSystem<RenderNode>
{
	
	var mRenderZone : Sprite;

	public function new() 
	{
		super(RenderNode, onNodeUpdate, onNodeAdded, onNodeRemoved);
		mRenderZone = Game.getI().getGameLayer();
	}
	
	function onNodeUpdate(node : RenderNode, delta : Float) 
	{
		var view = node.view;
		var transform = node.transform;
		
		view.x = transform.position.x;
		view.y = transform.position.y;
		
		view.rotation = transform.rotation;
		
		view.scaleX = transform.scale.x;
		view.scaleY = transform.scale.y;
	}
	
	function onNodeRemoved(node : RenderNode) 
	{
		mRenderZone.removeChild(node.view);
	}
	
	function onNodeAdded(node : RenderNode) 
	{
		mRenderZone.addChild(node.view);
	}
}