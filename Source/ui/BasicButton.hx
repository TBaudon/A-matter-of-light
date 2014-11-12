package ui;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author Thomas BAUDON
 */
class BasicButton extends Sprite
{

	public function new(text : String, w : Int, h : Int, color : UInt, txtColor : UInt) 
	{
		super();
		
		draw(text, w, h, color, txtColor);
	}
	
	function draw(text : String, w : Int, h : Int, color : UInt, txtColor : UInt):Void 
	{
		graphics.beginFill(color);
		graphics.drawRect(0, 0, w, h);
		graphics.endFill();
		
		var playTxt = new TextField();
		playTxt.selectable = false;
		playTxt.autoSize = TextFieldAutoSize.LEFT;
		playTxt.defaultTextFormat = new TextFormat("arial", 24, txtColor);
		playTxt.text = text;
		
		addChild(playTxt);
		playTxt.x = (width - playTxt.width) / 2;
		playTxt.y = (height - playTxt.height) / 2;
	}
	
}