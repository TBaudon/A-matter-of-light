package nodes;

import ash.core.Node;

import components.Body;
import components.PlayerControler;
import components.Transform;

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