package com.kazemir.mdt.screen;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

class SettingsMenu extends Screen
{
	public function new() 
	{
		super();
		
	}
	
	public override function begin()
	{
		super.begin();
		
		var img:Image = new Image("graphics/menu_settings.png");
		addGraphic(img);
	}
	
	public override function update()
	{
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") )
		{
			HXP.scene = new MenuScreen();
		}
		
		super.update();
	}
}