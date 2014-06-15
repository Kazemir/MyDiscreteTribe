package com.kazemir.mdt.screen;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.kazemir.mdt.Main;

class SplashScreen extends Screen
{
	private var base:Image;
	private var isDown:Bool;
	
#if flash
	private var frameCount:Int;
#end

	public function new() 
	{
		super();
		
		isDown = true;
	}
	
	public override function begin()
	{
		super.begin();
		
		base = Image.createRect(HXP.width, HXP.height, 0, 0.99);
        base.scrollX = base.scrollY = 0;
        addGraphic(base).layer = -5; 
		
		var base2 = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
        base2.scrollX = base2.scrollY = 0;
        addGraphic(base2).layer = 10; 
		
		var img:Image = new Image("graphics/kod_10._plemya.png"); 
		img.centerOrigin();
		img.scale = 1.0;
		addGraphic(img, 10, HXP.width / 2, HXP.height / 2);
		
#if flash
		frameCount = 0;
#end
	}
	
	public override function update()
	{
		if(base.alpha != 0 && isDown)
			base.alpha -= 0.02;
		else if (isDown && base.alpha == 0)
			isDown = false;
		else if(!isDown)
			base.alpha += 0.02;
		
		if (base.alpha == 1)
			HXP.scene = new MenuScreen();
			
		if (Input.pressed("esc") || Input.pressed("action") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.joyPressed("START") || Screen.joyPressed("A"))
		{
			HXP.scene = new MenuScreen();
		}
		
		super.update();
		
#if flash
		if (frameCount == 10)
		{
			if(!Main.focused)
				Main.setPause = true;
			frameCount++;
			
		}
		else if(frameCount < 10)
		{
			frameCount++;
		}
#end
	}
}