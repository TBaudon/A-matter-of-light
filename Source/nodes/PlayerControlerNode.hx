package nodes;
import ash.core.Node;
import components.PlayerControler;
import components.Transform;
import nape.phys.Body;

/**
 * ...
 * @author Thomas BAUDON
 */
class PlayerControlerNode extends Node<PlayerControlerNode>
{

	public var controler : PlayerControler;
	public var transform : Transform;
	public var body : Body;
	
}