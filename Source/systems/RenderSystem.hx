package systems;
import ash.core.Engine;
import ash.tools.ListIteratingSystem;
import core.Game;
import nodes.RenderNode;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Thomas BAUDON
 */
class RenderSystem extends ListIteratingSystem<RenderNode>
{
	
	var mRenderZone : Sprite;
	var mBuffer : BitmapData;
	var mBitmap : Bitmap;
	
	var mClearRect : Rectangle;
	var mSourceRect : Rectangle;
	var mDestPoint : Point;

	public function new() 
	{
		super(RenderNode, onNodeUpdate, onNodeAdded, onNodeRemoved);
		mRenderZone = Game.getI().getGameLayer();
		
		mBuffer = new BitmapData(400, 240, false, 0);
		mBitmap = new Bitmap(mBuffer, PixelSnapping.ALWAYS, false);
		mBitmap.scaleX = 2;
		mBitmap.scaleY = 2;		
		mClearRect = new Rectangle(0, 0, 400, 240);
		mSourceRect =  new Rectangle();
		mDestPoint = new Point();
	}
	
	override public function update(time:Float):Void 
	{
		mBuffer.lock();
		mBuffer.fillRect(mClearRect, 0);
		super.update(time);
		mBuffer.unlock();
	}
	
	function onNodeUpdate(node : RenderNode, delta : Float) 
	{
		var view = node.view;
		var transform = node.transform;
		
		mSourceRect.width = view.getWidth();
		mSourceRect.height = view.getHeight();
		
		mDestPoint.x = transform.position.x - view.origin.x * view.getWidth();
		mDestPoint.y = transform.position.y - view.origin.y * view.getHeight();
		
		if (view.source != null)
			mBuffer.copyPixels(view.source, mSourceRect, mDestPoint);
	}
	
	override public function addToEngine(engine:Engine):Void 
	{
		super.addToEngine(engine);
		mRenderZone.addChild(mBitmap);
	}
	
	function onNodeRemoved(node : RenderNode) 
	{
	}
	
	function onNodeAdded(node : RenderNode) 
	{
	}
}