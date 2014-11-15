package screens;

import core.Game;
import core.Screen;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import ui.BasicButton;

/**
 * ...
 * @author Thomas BAUDON
 */
class MenuScreen extends Screen
{

	public function new() 
	{
		super();
		
		var playBtn = new BasicButton("Play", 100, 30, 0x3333cc, 0xffffff);
		playBtn.addEventListener(MouseEvent.CLICK, onPlayPressed);
		mUiLayer.addChild(playBtn);
	}
	
	private function onPlayPressed(e:MouseEvent):Void 
	{
		Game.getI().gotoScreen(new GameScreen("testMap"));
	}
	
}