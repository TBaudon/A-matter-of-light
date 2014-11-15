package nodes.tileMap;
import ash.core.Node;
import components.tileMap.TileMap;
import components.tileMap.TileMapCollisionMask;

/**
 * ...
 * @author Thomas BAUDON
 */
class TileMapCollisionMaskNode extends Node<TileMapCollisionMaskNode>
{

	public var collisionMask : TileMapCollisionMask;
	public var map : TileMap;
	
}