package systems;
import ash.core.Engine;
import ash.core.NodeList;
import ash.tools.ListIteratingSystem;
import components.Body;
import components.tileMap.TileMap;
import geom.Vec2;
import nodes.CameraNode;
import nodes.TileMapNode;
import nodes.TileMapObjectNode;
import nodes.TileMapPhysicObjectNode;
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
	
	var mScrollX : Float;
	var mScrollY : Float;
	
	var mCameraNodeList : NodeList<CameraNode>;
	var mTileMapObjectNodeList:NodeList<TileMapObjectNode>;
	var mTileMapPhysicObjectNodeList : NodeList<TileMapPhysicObjectNode>;
	
	public function new() 
	{
		super(TileMapNode, onNodeUpdate, onNodeAdded, onNodeRemoved);
		
		mScrollX = 0;
		mScrollY = 0;
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
	
	override public function addToEngine(engine:Engine):Void 
	{
		super.addToEngine(engine);
		
		mCameraNodeList = engine.getNodeList(CameraNode);
		mTileMapObjectNodeList = engine.getNodeList(TileMapObjectNode);
		mTileMapPhysicObjectNodeList = engine.getNodeList(TileMapPhysicObjectNode);
	}
	
	override public function update(time:Float):Void 
	{
		super.update(time);
		
		updatePhysic();
		updateOffets();
	}
	
	function updatePhysic() 
	{
		var node = mTileMapPhysicObjectNodeList.head;
		
		while (node != null) {
			
			var position = node.body.position;
			
			
			
			node = node.next;
		}
	}
	
	function onNodeUpdate(node : TileMapNode, delta : Float) 
	{
		var tileMap = node.tileMap;
		var tileSet = tileMap.tileSet;
		var source = node.view.source;
		var tileSize = tileMap.tileSize;
			
		updateScroll(node, delta);
			
		// control max scroll
		// x
		if (mScrollX < 0)
			mScrollX = 0;
			
		if (mScrollX / tileMap.tileSize > tileMap.width - tileMap.scrollWidth+1)
			mScrollX = (tileMap.width - tileMap.scrollWidth + 1) * tileMap.tileSize;
		// y
		if (mScrollY < 0)
			mScrollY = 0;
			
		if (mScrollY / tileMap.tileSize > tileMap.height - tileMap.scrollHeight+1)
			mScrollY = (tileMap.height - tileMap.scrollHeight+1) * tileMap.tileSize;
		
		// draw map in view
		if (tileSet != null) {
			source.lock();
			
			source.fillRect(node.view.region, 0x00000000);
			
			var startI : Int = Std.int(mScrollY / tileMap.tileSize);
			var startJ : Int = Std.int(mScrollX / tileMap.tileSize);
			
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
					destX -= cast mScrollX;
					var destY = i * tileSize;
					destY -= cast mScrollY;
					source.copyPixels(tileSet, rect, new Point(destX, destY));
				}
			
			source.unlock();
		}
	}
	
	function updateScroll(node:TileMapNode, delta:Float) 
	{
		var cameraNode = mCameraNodeList.head;
		
		if(cameraNode != null){
			var camPos = cameraNode.transform.position;
			var off = cameraNode.transform.offset;
			
			var tileMap = node.tileMap;
			
			if (camPos.y + off.y > 240) 
				mScrollY += camPos.y + off.y - 240;
			
			if (camPos.x + off.x > 400) {
				mScrollX += camPos.x + off.x - 400;
			}else if (camPos.x + off.x < 0) {
				mScrollX += camPos.x + off.x;
			}
		}
	}
	
	function getTile(tileMap : TileMap, tileSet : BitmapData, tile : Int) : Rectangle {
		tile --;
		var l = tileSet.width / tileMap.tileSize;
		
		var x = tile % l;
		var y = Std.int(tile / l);
		
		return new Rectangle(x * tileMap.tileSize, y * tileMap.tileSize, tileMap.tileSize, tileMap.tileSize);
	}
	
	function updateOffets():Void 
	{
		var node = mTileMapObjectNodeList.head;
		
		while (node != null) {
			
			node.transform.offset.x = -mScrollX;
			node.transform.offset.y = -mScrollY;
			
			node = node.next;
		}
	}
	
}