package com.kazemir.mdt.screen;

import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Touch;
import com.haxepunk.utils.Data;

import flash.system.System;

import com.kazemir.mdt.MusicManager;

#if !flash
import sys.io.File;
import sys.FileSystem;
#end

#if android
import openfl.Assets;
import openfl.utils.SystemPath;
#end

class Screen extends Scene
{
	public static var music:MusicManager;
	public static var overrideControlByBox:Bool;
	
#if flash
	public static var focusLostScreen:Image;
	//public static var isFirstTime
#end
	
	public function new() 
	{
		super();
		
		overrideControlByBox = false;
		
		if(music == null)
			music = new MusicManager();
			
#if flash
		if (focusLostScreen == null)
		{
			focusLostScreen = new Image("graphics/lostFocus.png");
			focusLostScreen.scrollX = focusLostScreen.scrollY = 0;
			focusLostScreen.visible = true;
		}
		addGraphic(focusLostScreen, -999);
#end
	}
	
	public override function begin()
	{
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("esc", [Key.ESCAPE, Key.BACKSPACE]);
		Input.define("action", [Key.ENTER, Key.X, Key.SPACE]);
		
		super.begin();
	}
	
	public override function update()
	{
		super.update();
		music.update();
		
		prevHatX = Input.joystick(0).hat.x;
		prevHatY = Input.joystick(0).hat.y;
		
#if flash
		if (Main.focused)
			Screen.focusLostScreen.visible = false;
		else
			Screen.focusLostScreen.visible = true;
#end
	}
	
	private function ExitGame()
	{
		music.stop();
		SaveSettings();
		System.exit(0);
	}
	
	public function SaveSettings()
	{
		var config:Xml = Xml.createElement("settings");

		config.set("sound", Std.string(SettingsMenu.soudVolume));
		config.set("music", Std.string(SettingsMenu.musicVolume));
			
#if android
		File.saveContent(SystemPath.applicationStorageDirectory + "/config.xml", config.toString());
#elseif flash
		Data.load("mdt_data");
		Data.write("settings", config.toString());
		Data.save("mdt_data", true);
#else
		File.saveContent("config.xml", config.toString());
#end
	}
	
	public static function joyCheck(key:String):Bool
	{
		switch(key)
		{
			case "A":
				return Input.joystick(0).check(0);
			case "B":
				return Input.joystick(0).check(1);
			case "Y":
				return Input.joystick(0).check(3);
			case "X":
				return Input.joystick(0).check(2);
			case "LB":
				return Input.joystick(0).check(4);
			case "RB":
				return Input.joystick(0).check(5);
			case "DPAD_UP":
				if (Input.joystick(0).hat.y == -1)
					return true;
				else
					return false;
			case "DPAD_DOWN":
				if (Input.joystick(0).hat.y == 1)
					return true;
				else
					return false;
			case "DPAD_LEFT":
				if (Input.joystick(0).hat.x == -1)
					return true;
				else
					return false;
			case "DPAD_RIGHT":
				if (Input.joystick(0).hat.x == 1)
					return true;
				else
					return false;
			case "BACK":
				return Input.joystick(0).check(6);
			case "START":
				return Input.joystick(0).check(7);
			case "LS_BUTTON":
				return Input.joystick(0).check(8);
			case "RS_BUTTON":
				return Input.joystick(0).check(9);
		}
		return false;
	}
	
	private static var prevHatX:Float = 0;
	private static var prevHatY:Float = 0;
	
	public static function joyPressed(key:String):Bool
	{
		switch(key)
		{
			case "A":
				return Input.joystick(0).pressed(0);
			case "B":
				return Input.joystick(0).pressed(1);
			case "Y":
				return Input.joystick(0).pressed(3);
			case "X":
				return Input.joystick(0).pressed(2);
			case "LB":
				return Input.joystick(0).pressed(4);
			case "RB":
				return Input.joystick(0).pressed(5);
			case "DPAD_UP":
				if (Input.joystick(0).hat.y == -1 && prevHatY != -1)
					return true;
				else
					return false;
			case "DPAD_DOWN":
				if (Input.joystick(0).hat.y == 1 && prevHatY != 1)
					return true;
				else
					return false;
			case "DPAD_LEFT":
				if (Input.joystick(0).hat.x == -1  && prevHatX != -1)
					return true;
				else
					return false;
			case "DPAD_RIGHT":
				if (Input.joystick(0).hat.x == 1 && prevHatX != 1)
					return true;
				else
					return false;
			case "BACK":
				return Input.joystick(0).pressed(6);
			case "START":
				return Input.joystick(0).pressed(7);
			case "LS_BUTTON":
				return Input.joystick(0).pressed(8);
			case "RS_BUTTON":
				return Input.joystick(0).pressed(9);
		}
		return false;
	}
}