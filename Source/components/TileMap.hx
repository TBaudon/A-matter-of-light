package components;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 * ...
 * @author Thomas BAUDON
 */
class TileMap
{
	
	public var width : Int;
	public var height : Int;
	public var tileSize : Int;
	
	public var scrollWidth : Int = 10;
	public var scrollHeight : Int = 10;
	
	public var scrollX : Int = 0;
	public var scrollY : Int = 0;

	public var map : Array<Array<Int>>;
	
	public var tileSet : BitmapData;
	
	public function new(width : Int, height : Int, tileSize : Int) 
	{
		this.width = width;
		this.height = height;
		this.tileSize = tileSize;
		
		map = new Array<Array<Int>>();
		
		for (i in 0 ... height) {
			var line = new Array<Int>();
			for (j in 0 ... width) 
				line.push(0);
			map.push(line);
		}
	}
	
}