package systems;
import ash.core.Engine;
import ash.core.NodeList;
import ash.tools.ListIteratingSystem;
import components.Body;
import components.tileMap.TileMap;
import components.tileMap.TileMapCollisionMask;
import geom.Segment;
import geom.Vec2;
import nodes.CameraNode;
import nodes.tileMap.TileMapCollisionMaskNode;
import nodes.tileMap.TileMapNode;
import nodes.tileMap.TileMapObjectNode;
import nodes.tileMap.TileMapPhysicObjectNode;
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
	var mTileMapCollisionMaskNodeList:NodeList<TileMapCollisionMaskNode>;
	
	var mCollisionMask : Array<Int>;
	
	var mMapWidth : Int;
	var mMapHeight : Int;
	var mTileSize : Int;
	var mTileSide : Array<Segment>;
	
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
		
		mTileMapCollisionMaskNodeList = engine.getNodeList(TileMapCollisionMaskNode);
		mTileMapCollisionMaskNodeList.nodeAdded.add(onCollisionMaskAdded);
		mTileMapCollisionMaskNodeList.nodeRemoved.add(onCollisionMaskRemoved);
	}
	
	function onCollisionMaskRemoved(node : TileMapCollisionMaskNode) 
	{
		mCollisionMask = null;
	}
	
	function onCollisionMaskAdded(node: TileMapCollisionMaskNode) 
	{
		mCollisionMask = node.entity.get(TileMap).data;
		mMapWidth = node.entity.get(TileMap).width;
		mMapHeight = node.entity.get(TileMap).height;
		mTileSize = node.entity.get(TileMap).tileSize;
		
		mTileSide = new Array<Segment>();
		
		mTileSide.push(new Segment(0, 0, mTileSize, 0)); 
		mTileSide.push(new Segment(mTileSize, 0, mTileSize, mTileSize)); 
		mTileSide.push(new Segment(mTileSize, mTileSize, 0, mTileSize)); 
		mTileSide.push(new Segment(0, mTileSize, 0, 0)); 
	}
	
	override public function update(time:Float):Void 
	{
		updatePhysic(time);
		super.update(time);
		updateOffsets();
	}
	
	function updatePhysic(time : Float) 
	{
		if(mCollisionMask != null){
			var node = mTileMapPhysicObjectNodeList.head;
		
			while (node != null) {
				
				var body = node.body;
				//body.velocity.y += 9.8;
				var position = node.body.position;
				var velocity = Vec2.Mul(node.body.velocity, time);
				
				var nextPosition = Vec2.Add(position, velocity);
				
				if (getDataAt(nextPosition) != 0) {
					
					//step 1 : get tilePos
					var tilePos = getTilePos(nextPosition);
					
					// step 2 : get position relative to tile upper left corner
					var relPos = Vec2.Sub(nextPosition, tilePos);
					
					// step 3 : get the velocity segment
					var start = relPos;
					var end = Vec2.Sub(relPos, Vec2.Mul(velocity, 1000));
					var velSeg = new Segment(start.x, start.y, end.x, end.y);
					// step 4 : check for intersection with all tile side
					var collisionPoint : Vec2 = null;
					for ( side in mTileSide) {
						collisionPoint = velSeg.intersect(side);
						if (collisionPoint != null) break;
					}
					
					if (collisionPoint != null) {
						body.velocity.y = 0;
						// step 5 : set position back to colision pos
						position.x = tilePos.x + collisionPoint.x + body.velocity.x * time;
						position.y = tilePos.y + collisionPoint.y + body.velocity.y * time;
						// dstep 6 : get normal
					}
					//body.velocity.mul(0);
					//position.y = Std.int(position.y / mTileSize) * mTileSize;
				}else {
					position.x += velocity.x;
					position.y += velocity.y;
				}
			
				node = node.next;
			}
		}
	}
	
	function getDataAt(position : Vec2) : Int{
		if (mCollisionMask == null) return 0;
		
		var x = Std.int(position.x / mTileSize);
		var y = Std.int(position.y / mTileSize);
		
		var data = mCollisionMask[Std.int(y * mMapWidth + x)];
		return data;
	}
	
	function getTilePos(position : Vec2) : Vec2 {
		var x = Std.int(position.x / mTileSize) * mTileSize;
		var y = Std.int(position.y / mTileSize) * mTileSize;
		return new Vec2(x, y);
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
			
			if (camPos.y + off.y > 200) 
				mScrollY += camPos.y + off.y - 200;
			
			if (camPos.x + off.x > 300) {
				mScrollX += camPos.x + off.x - 300;
			}else if (camPos.x + off.x < 100) {
				mScrollX += camPos.x + off.x - 100;
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
	
	function updateOffsets():Void 
	{
		var node = mTileMapObjectNodeList.head;
		
		while (node != null) {
			
			node.transform.offset.x = -mScrollX;
			node.transform.offset.y = -mScrollY;
			
			node = node.next;
		}
	}
	
}