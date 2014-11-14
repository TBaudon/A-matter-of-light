package systems;
import ash.tools.ListIteratingSystem;
import components.TileMap;
import geom.Vec2;
import nodes.TileMapNode;
import openfl.display.BitmapData;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Thomas BAUDON
 */
class TileMapSystem extends ListIteratingSystem<TileMapNode>
{
	var mScrollLeft : Bool;
	var mScrollRight : Bool;
	
	public function new() 
	{
		super(TileMapNode, onNodeUpdate, onNodeAdded, onNodeRemoved);
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKUp);
	}
	
	private function onKUp(e:KeyboardEvent):Void 
	{
		if(e.keyCode == Keyboard.LEFT)
			mScrollLeft = false;
		if (e.keyCode == Keyboard.RIGHT)
			mScrollRight = false;
	}
	
	private function onKDown(e:KeyboardEvent):Void 
	{
		if(e.keyCode == Keyboard.LEFT)
			mScrollLeft = true;
		if (e.keyCode == Keyboard.RIGHT)
			mScrollRight = true;
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
		
		tileMap.scrollWidth = Std.int(Lib.current.stage.stageWidth/2 / tileMap.tileSize)+1;
		tileMap.scrollHeight = Std.int(Lib.current.stage.stageHeight/2 / tileMap.tileSize)+1;
		
		view.source = new BitmapData(tileMap.scrollWidth * tileMap.tileSize, tileMap.scrollHeight * tileMap.tileSize);
		view.region = new Rectangle(0, 0, view.source.width, view.source.height);
	}
	
	function onNodeUpdate(node : TileMapNode, delta : Float) 
	{
		var tileMap = node.tileMap;
		var tileSet = tileMap.tileSet;
		var source = node.view.source;
		var tileSize = tileMap.tileSize;
		
		if (mScrollLeft)
			tileMap.scrollX -= 20;
			
		if (mScrollRight)
			tileMap.scrollX += 20;
			
		// control max scroll
		// x
		if (tileMap.scrollX < 0)
			tileMap.scrollX = 0;
			
		if (tileMap.scrollX / tileMap.tileSize > tileMap.width - tileMap.scrollWidth+1)
			tileMap.scrollX = (tileMap.width - tileMap.scrollWidth + 1) * tileMap.tileSize;
		// y
		if (tileMap.scrollY < 0)
			tileMap.scrollY = 0;
			
		if (tileMap.scrollY / tileMap.tileSize > tileMap.height - tileMap.scrollHeight+1)
			tileMap.scrollY = (tileMap.height - tileMap.scrollHeight+1) * tileMap.tileSize;
		
		// draw map in view
		if (tileSet != null) {
			source.lock();
			
			source.fillRect(node.view.region, 0x00000000);
			
			var startI : Int = Std.int(tileMap.scrollY / tileMap.tileSize);
			var startJ : Int = Std.int(tileMap.scrollX / tileMap.tileSize);
			
			var endI : Int;
			var endJ : Int;
			
			if (startI + tileMap.scrollHeight < tileMap.height)
				endI = startI + tileMap.scrollHeight;
			else
				endI = tileMap.height;
				
			if (startJ + tileMap.scrollWidth < tileMap.width)
				endJ = startJ + tileMap.scrollWidth;
			else
				endJ = tileMap.width;
			
			for (i in startI ... endI) 
				for (j in startJ ... endJ) {
					var rect = getTile(tileMap, tileSet, tileMap.data[i * tileMap.width + j]);
					var destX = j * tileSize;
					destX -= tileMap.scrollX;
					var destY = i * tileSize;
					source.copyPixels(tileSet, rect, new Point(destX, destY));
				}
			
			source.unlock();
		}
	}
	
	function getTile(tileMap : TileMap, tileSet : BitmapData, tile : Int) : Rectangle {
		tile --;
		var l = tileSet.width / tileMap.tileSize;
		
		var x = tile % l;
		var y = Std.int(tile / l);
		
		return new Rectangle(x * tileMap.tileSize, y * tileMap.tileSize, tileMap.tileSize, tileMap.tileSize);
	}
	
}