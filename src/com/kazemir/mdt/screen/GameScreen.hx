package com.kazemir.mdt.screen;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

import com.kazemir.mdt.TileGrid;
import com.kazemir.mdt.YesNoBox;

class GameScreen extends Screen
{
	private var tileGrid:TileGrid;
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		super.begin();
		
		var base2 = Image.createRect(HXP.width, HXP.height, 0xe6e3c4, 1);
        base2.scrollX = base2.scrollY = 0;
        addGraphic(base2).layer = 10; 
		
		var img:Image = new Image("graphics/gameScreen.png");
		addGraphic(img);
		
	}
	
	public override function update()
	{
		if ((Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B")) && !Screen.overrideControlByBox)
		{
			var yesNoBox:YesNoBox = new YesNoBox(HXP.halfWidth, HXP.halfHeight, "Выходъ въ меню", "Вы действительно хотите выйти в главное меню?");
			add(yesNoBox);
			//Screen.music.goMenuMusic();
			//HXP.scene = new MenuScreen();
		}
		
		super.update();
	}
}