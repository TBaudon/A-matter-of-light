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

	public var data : Array<Int>;
	
	public var tileSet : BitmapData;
	
	public function new(width : Int, height : Int, tileSize : Int, data : Array<Int> = null) 
	{
		this.width = width;
		this.height = height;
		this.tileSize = tileSize;
		
		if(data != null)
			this.data = data;
		else {
			data = new Array<Int>();
			
			for (i in 0 ... height * width)
				data.push(0);
		}
	}
	
}