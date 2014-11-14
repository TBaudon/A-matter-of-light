package systems;
import ash.tools.ListIteratingSystem;
import components.TileMap;
import geom.Vec2;
import nodes.TileMapNode;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Thomas BAUDON
 */
class TileMapSystem extends ListIteratingSystem<TileMapNode>
{

	public function new() 
	{
		super(TileMapNode, onNodeUpdate, onNodeAdded, onNodeRemoved);
	}
	
	function onNodeRemoved(node : TileMapNode) 
	{
		var view = node.view;
		
		view.region = null;
		view.source.dispose();
		view.source = null;
	}
	
	function onNodeAdded(node : TileMapNode) 
	{
		var tileMap = node.tileMap;
		var view = node.view;
		
		view.source = new BitmapData(tileMap.scrollWidth * tileMap.tileSize, tileMap.scrollHeight * tileMap.tileSize);
		view.region = new Rectangle(0,0,view.source.width, view.source.height);
	}
	
	function onNodeUpdate(node : TileMapNode, delta : Float) 
	{
		var tileMap = node.tileMap;
		var tileSet = tileMap.tileSet;
		var source = node.view.source;
		var tileSize = tileMap.tileSize;
		
		if (tileSet != null) {
			source.lock();
			
			source.fillRect(node.view.region, 0x00000000);
			
			for (i in 0 ... tileMap.scrollHeight) 
				for (j in 0 ... tileMap.scrollWidth) {
					var rect = getTile(tileMap, tileSet, tileMap.map[i][j]);
					source.copyPixels(tileSet, rect, new Point(j * tileSize, i * tileSize));
				}
			
			source.unlock();
		}
	}
	
	function getTile(tileMap : TileMap, tileSet : BitmapData, tile : Int) : Rectangle {
		var l = tileSet.width / tileMap.tileSize;
		
		var x = tile % l;
		var y = Std.int(tile / l);
		
		return new Rectangle(x * tileMap.tileSize, y * tileMap.tileSize, tileMap.tileSize, tileMap.tileSize);
	}
	
}