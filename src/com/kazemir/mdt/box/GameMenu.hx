package com.kazemir.mdt.box;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.kazemir.mdt.screen.GameScreen;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;

import com.kazemir.mdt.utils.DrawText;
import com.kazemir.mdt.screen.Screen;
import com.kazemir.mdt.screen.MenuScreen;
import com.kazemir.mdt.screen.SettingsMenu;

class GameMenu extends Entity
{
	private var captionText:DrawText;
	private static var minW:Int = 240;
	private static var scale:Float = 1.5;
	
	private var textMenuElements:Array<DrawText> = new Array<DrawText>();
	private var currentMenuElement:Int = 0;
	
	private var passiveColor = 0x000000;
	private var activeColor = 0xFF0000;
	
	private var settingsOn:Bool;
	
	private var currentScene:GameScreen;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		var sprite:Sprite = new Sprite();
        var g:Graphics = sprite.graphics;
		
		captionText = new DrawText("Пауза", GameFont.Tsarevich, Std.int(28*scale), Std.int(150*scale), Std.int(16*scale), 0, true);
		
		var frameW:Int = Std.int(minW*scale);
		if (captionText.label.width + Std.int(10*scale) > Std.int(minW*scale))
			frameW = captionText.label.width + Std.int(10*scale);
			
		captionText.label.x = frameW / 2;
		
		var msgFrameH:Int = Std.int(65*scale);
		
		textMenuElements.push(new DrawText("Продолжить игру", GameFont.TriodPostnaja, Std.int(16*scale), frameW / 2, Std.int(38*scale), activeColor, true));
		textMenuElements.push(new DrawText("Настройки", GameFont.TriodPostnaja, Std.int(16*scale), frameW / 2, Std.int(58*scale), passiveColor, true));
		textMenuElements.push(new DrawText("Выходъ", GameFont.TriodPostnaja, Std.int(16*scale), frameW / 2, Std.int(78*scale), passiveColor, true));
		textMenuElements.push(new DrawText("Звукъ:", GameFont.TriodPostnaja, Std.int(16*scale), Std.int(6*scale), Std.int(30*scale), passiveColor, false));
		textMenuElements.push(new DrawText("Музыка:", GameFont.TriodPostnaja, Std.int(16*scale), Std.int(6*scale), Std.int(60*scale), passiveColor, false));
		
		textMenuElements.push(new DrawText("//////----", GameFont.TriodPostnaja, Std.int(16*scale), frameW - frameW/3, Std.int(30*scale), activeColor, false));
		textMenuElements.push(new DrawText("/////////-", GameFont.TriodPostnaja, Std.int(16*scale), frameW - frameW/3, Std.int(60*scale), passiveColor, false));
		
		for (x in textMenuElements)
			x.label.scrollX = x.label.scrollY = 0;
			
		textMenuElements[3].label.visible = false;
		textMenuElements[4].label.visible = false;
		textMenuElements[5].label.visible = false;
		textMenuElements[6].label.visible = false;
		
		settingsOn = false;
		
		g.beginFill(0);
		g.drawRoundRect(0, 0, frameW, Std.int(28*scale + msgFrameH + 4*scale), 0);
		g.endFill();
		g.beginFill(0xad1e1e);
		g.drawRoundRect(Std.int(1*scale), Std.int(1*scale), Std.int(frameW - 2*scale), Std.int(28*scale + msgFrameH + 2*scale), 0);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(Std.int(2*scale), Std.int(2*scale), Std.int(frameW - 4*scale), Std.int(24*scale), 0);
		g.endFill();
		g.beginFill(0xe6e3c4);
		g.drawRoundRect(Std.int(3*scale), Std.int(3*scale), Std.int(frameW - 6*scale), Std.int(22*scale), 0);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(Std.int(2*scale), Std.int(27*scale), Std.int(frameW - 4*scale), Std.int(msgFrameH + 3*scale), 0);
		g.endFill();
		g.beginFill(0xe6e3c4);
		g.drawRoundRect(Std.int(3*scale), Std.int(28*scale), Std.int(frameW - 6*scale), Std.int(msgFrameH + 1*scale), 0);
		g.endFill();
		
		var img:BitmapData = new BitmapData(frameW, Std.int(28*scale + msgFrameH + 4*scale), true, 0xe6e3c4);
		img.draw(sprite);
		
		graphic = new Stamp(img);
		graphic.scrollX = graphic.scrollY = 0;
		
		addGraphic(captionText.label);
		captionText.label.scrollX = captionText.label.scrollY = 0;
		
		for (i in 0...textMenuElements.length) 
		{
			addGraphic(textMenuElements[i].label);
		}
		changeMenu();
		
		graphic.x -= frameW / 2;
		graphic.y -= 16 * scale + msgFrameH / 2;
		
		layer = -50;
		
		Screen.overrideControlByBox = true;
	}
	
	public override function added()
	{
		currentScene = cast(scene, GameScreen);
	}
	
	public function changeMenu()
	{
		if (!settingsOn)
		{
			if (currentMenuElement < 0)
				currentMenuElement = 2;
			if (currentMenuElement > 2)
				currentMenuElement = 0;
		}
		else 
		{
			if (currentMenuElement < 5)
				currentMenuElement = 6;
			if (currentMenuElement > 6)
				currentMenuElement = 5;
		}
		
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
		for (i in 0...SettingsMenu.soudVolume)
			temp += "/";
		for (i in SettingsMenu.soudVolume...10)
			temp += "-";
		textMenuElements[5].ChangeStr(temp, false);
		
		temp = "";
		for (i in 0...SettingsMenu.musicVolume)
			temp += "/";
		for (i in SettingsMenu.musicVolume...10)
			temp += "-";
		textMenuElements[6].ChangeStr(temp, false);
	}

	public function actionMenu(positive:Bool = true)
	{
		switch(currentMenuElement)
		{
			case 0:
				Screen.overrideControlByBox = false;
				this.scene.remove(this);
			case 1:
				settingsOn = true;
				textMenuElements[0].label.visible = false;
				textMenuElements[1].label.visible = false;
				textMenuElements[2].label.visible = false;
				
				textMenuElements[3].label.visible = true;
				textMenuElements[4].label.visible = true;
				textMenuElements[5].label.visible = true;
				textMenuElements[6].label.visible = true;
				
				currentMenuElement = 5;
				changeMenu();
				updateMenu();
			case 2:
				Screen.overrideControlByBox = false;
				this.scene.remove(this);
				Screen.music.goMenuMusic();
				HXP.scene = new MenuScreen();
			case 5:
				if(positive)
					SettingsMenu.soudVolume++;
				else
					SettingsMenu.soudVolume--;
				if (SettingsMenu.soudVolume < 0)
					SettingsMenu.soudVolume = 0;
				if (SettingsMenu.soudVolume > 10)
					SettingsMenu.soudVolume = 10;	
			case 6:
				if(positive)
					SettingsMenu.musicVolume++;
				else
					SettingsMenu.musicVolume--;
				if (SettingsMenu.musicVolume < 0)
					SettingsMenu.musicVolume = 0;
				if (SettingsMenu.musicVolume > 10)
					SettingsMenu.musicVolume = 10;
				Screen.music.currentMusic.volume = SettingsMenu.musicVolume / 10;
		}
	}
	
	public override function update()
	{
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B"))
		{
			if (!settingsOn)
			{
				Screen.overrideControlByBox = false;
				this.scene.remove(this);
			}
			else
			{
				settingsOn = false;
				textMenuElements[0].label.visible = true;
				textMenuElements[1].label.visible = true;
				textMenuElements[2].label.visible = true;
				
				textMenuElements[3].label.visible = false;
				textMenuElements[4].label.visible = false;
				textMenuElements[5].label.visible = false;
				textMenuElements[6].label.visible = false;
		
				currentMenuElement = 0;
				changeMenu();
				Screen.SaveSettings();
			}
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
		if ((Input.pressed("action") || Screen.joyPressed("START") || Screen.joyPressed("A")) && !settingsOn)
		{
			actionMenu();
		}
		if (Input.pressed("left") || Screen.joyPressed("DPAD_LEFT"))
		{
			actionMenu(false);
			updateMenu();
		}
		if (Input.pressed("right") || Screen.joyPressed("DPAD_RIGHT"))
		{
			actionMenu(true);
			updateMenu();
		}
		
		super.update();
	}
}