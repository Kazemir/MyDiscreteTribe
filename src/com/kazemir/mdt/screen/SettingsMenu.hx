package com.kazemir.mdt.screen;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

import com.kazemir.mdt.utils.DrawText;

class SettingsMenu extends Screen
{
	private var textMenuElements:Array<DrawText> = new Array<DrawText>();
	private var currentMenuElement:Int = 0;
	
	private var passiveColor = 0x000000;
	private var activeColor = 0xFF0000;
	
	public static var soudVolume:Int = 6;
	public static var musicVolume:Int = 9;
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		super.begin();
		
		var img:Image = new Image("graphics/menu_settings.png");
		addGraphic(img);
		
		addGraphic(DrawText.CreateTextEntity("Звукъ:", GameFont.TriodPostnaja, 38, 150, 280, 0x0, false));
		addGraphic(DrawText.CreateTextEntity("Музыка:", GameFont.TriodPostnaja, 38, 150, 320, 0x0, false));
	
		textMenuElements.push(new DrawText("//////----", GameFont.TriodPostnaja, 38, 475, 280, activeColor, false));
		textMenuElements.push(new DrawText("/////////-", GameFont.TriodPostnaja, 38, 475, 320, passiveColor, false));
	
		for (i in 0...textMenuElements.length) 
		{
			addGraphic(textMenuElements[i].label);
		}
		
		updateMenu();
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
	
	private function updateMenu()
	{
		var temp:String = "";
		for (i in 0...soudVolume)
			temp += "/";
		for (i in soudVolume...10)
			temp += "-";
		textMenuElements[0].ChangeStr(temp, false);
		
		temp = "";
		for (i in 0...musicVolume)
			temp += "/";
		for (i in musicVolume...10)
			temp += "-";
		textMenuElements[1].ChangeStr(temp, false);
	}
	
public function actionMenu(positive:Bool)
	{
		switch(currentMenuElement)
		{
			case 0:
				if(positive)
					soudVolume++;
				else
					soudVolume--;
				if (soudVolume < 0)
					soudVolume = 0;
				if (soudVolume > 10)
					soudVolume = 10;	
			case 1:
				if(positive)
					musicVolume++;
				else
					musicVolume--;
				if (musicVolume < 0)
					musicVolume = 0;
				if (musicVolume > 10)
					musicVolume = 10;
		}
		Screen.music.currentMusic.volume = SettingsMenu.musicVolume / 10;
		updateMenu();
	}
	
	public override function update()
	{
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") )
		{
			Screen.SaveSettings();
			HXP.scene = new MenuScreen();
		}
		if (Input.pressed("up") || Screen.joyPressed("DPAD_UP"))
		{
			currentMenuElement--;
		}
		if (Input.pressed("down") || Screen.joyPressed("DPAD_DOWN"))
		{
			currentMenuElement++;
		}
		if (Input.pressed("left") || Screen.joyPressed("DPAD_LEFT"))
		{
			actionMenu(false);
		}
		if (Input.pressed("right") || Screen.joyPressed("DPAD_RIGHT"))
		{
			actionMenu(true);
		}
		changeMenu();
		
		super.update();
	}
}