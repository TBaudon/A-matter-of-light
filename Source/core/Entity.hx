package core ;
import geom.Vec2;
import openfl.display.BitmapData;

/**
 * ...
 * @author Thomas BAUDON
 */
class Entity
{
	
	public var pos : Vec2;
	public var vel : Vec2;
	public var scale : Vec2;
	public var rot : Float;
	
	public var parent : Entity;
	public var children : Array<Entity>;
	
	public var name : String;
	
	var mDim : Vec2;

	public function new(name : String = "") {
		this.name = name;
		
		pos = new Vec2();
		scale = new Vec2(1, 1);
		vel = new Vec2(0, 0);
		rot = 0;
		mDim = new Vec2(0, 0);
		
		children = new Array<Entity>();
	}
	
	public function _update(delta : Float) {
		update(delta);
		
		for (child in children)
			child._update(delta);
	}
	
	function update(delta : Float) {
		
	}
	
	public function _draw(buffer : BitmapData, dest : Vec2) {
		draw(buffer, dest);
		
		for(child in children)
			child._draw(buffer, Vec2.Add(dest, child.pos));
	}
	
	function draw(buffer : BitmapData, dest : Vec2) {
		
	}
	
	public function add(child : Entity) {
		children.push(child);
		child.parent = this;
	}
	
	public function remove(child : Entity) {
		children.remove(child);
		child.parent = null;
	}
	
	public function setDim(x : Int, y : Int) {
		mDim.set(x, y);
	}
	
	public function destroy() {
		
	}
	
}