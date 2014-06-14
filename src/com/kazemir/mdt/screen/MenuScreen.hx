package com.kazemir.mdt.screen;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.kazemir.mdt.DrawText;

import flash.system.System;

class MenuScreen extends Screen
{
	private var textMenuElements:Array<DrawText> = new Array<DrawText>();
	private static var currentMenuElement:Int = 0;
	
	private var passiveColor = 0x000000;
	private var activeColor = 0xFF0000;
	
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
		
		var img:Image = new Image("graphics/menu.png");
		addGraphic(img);
		
		textMenuElements.push(new DrawText("Начать игру", GameFont.TriodPostnaja, 38, HXP.halfWidth, 240, activeColor, true));
		textMenuElements.push(new DrawText("Настройки", GameFont.TriodPostnaja, 38, HXP.halfWidth, 280, passiveColor, true));
		textMenuElements.push(new DrawText("Помощь", GameFont.TriodPostnaja, 38, HXP.halfWidth, 320, passiveColor, true));
		textMenuElements.push(new DrawText("Авторы", GameFont.TriodPostnaja, 38, HXP.halfWidth, 360, passiveColor, true));
#if windows
		textMenuElements.push(new DrawText("Выход", GameFont.TriodPostnaja, 38, HXP.halfWidth, 400, passiveColor, true));
#end
		
		for (i in 0...textMenuElements.length) 
		{
			addGraphic(textMenuElements[i].label);
		}
		
		changeMenu();
	}
	
	public function changeMenu()
	{
		if (currentMenuElement < 0)
			currentMenuElement = textMenuElements.length - 1;
		if (currentMenuElement > textMenuElements.length - 1)
			currentMenuElement = 0;
		
		for (i in 0...textMenuElements.length) 
		{
			if(i != currentMenuElement)
				textMenuElements[i].ChangeColor(passiveColor);
			else
				textMenuElements[i].ChangeColor(activeColor);
		}
	}
	
	public function actionMenu()
	{
		switch(currentMenuElement)
		{
			case 0:
				Screen.music.goGameMusic();
				HXP.scene = new GameScreen();
			case 1:
				HXP.scene = new SettingsMenu();
			case 2:
				HXP.scene = new HelpScreen();
			case 3:
				HXP.scene = new CreatorsScreen();
			case 4:
				ExitGame();
		}
	}

	public override function update()
	{
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") )
		{
#if windows
			ExitGame();
#end
		}
		if (Input.pressed("up") || Screen.joyPressed("DPAD_UP"))
		{
			currentMenuElement--;
			changeMenu();
		}
		if (Input.pressed("down") || Screen.joyPressed("DPAD_DOWN"))
		{
			currentMenuElement++;
			changeMenu();
		}
		if (Input.pressed("action") || Screen.joyPressed("START") || Screen.joyPressed("A"))
		{
			actionMenu();
		}
		
		super.update();
	}
}