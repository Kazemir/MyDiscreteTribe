package com.kazemir.mdt;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.haxepunk.utils.Data;

import com.kazemir.mdt.screen.SplashScreen;
import com.kazemir.mdt.screen.SettingsMenu;

#if android
import openfl.utils.SystemPath;
#end

#if !flash
import sys.FileSystem;
import sys.io.File;
#end

class Main extends Engine
{
#if flash
	public static var focused:Bool;
	public static var setPause:Bool;
#end
	
	public function new()
	{
#if !flash
		super(800, 600, 30, true, RenderMode.HARDWARE);
#else	
		super(800, 600, 30, true, RenderMode.BUFFER);
#end
	}
	
	override public function init()
	{
#if debug
		HXP.console.enable();
		HXP.console.log(["The game has started!"]);
#end
#if flash
		focused = HXP.focused;
		setPause = false;
#end
		LoadConfig();
		HXP.scene = new SplashScreen();
	}

	public static function main() 
	{ 
		new Main(); 
	}
	
#if flash
	override public function focusLost () 
	{
		focused = false;
	}
	
	override public function focusGained () 
	{
		paused = false;
		focused = true;
	}
	
	override public function update() 
	{
		if (setPause)
		{
			paused = true;
			setPause = false;
		}
		
		super.update();
	}
#end

	private static function LoadConfig()
	{
		var config:Xml;
#if android
		if ( FileSystem.exists(SystemPath.applicationStorageDirectory + "/config.xml") )
		{
			config = Xml.parse(File.getContent( SystemPath.applicationStorageDirectory + "/config.xml" )).firstElement();
#elseif flash
		Data.load("mdt_data");
		if (Data.read("settings") != null)
		{
			config = Xml.parse(Data.read("settings")).firstElement();
#else
		if ( FileSystem.exists("config.xml") )
		{
			config = Xml.parse(File.getContent( "config.xml" )).firstElement();
#end
			SettingsMenu.soudVolume = Std.parseInt(config.get("sound"));
			SettingsMenu.musicVolume = Std.parseInt(config.get("music"));
		}
		else
		{
			config = Xml.createElement("settings");
			
			config.set("sound", Std.string(SettingsMenu.soudVolume));
			config.set("music", Std.string(SettingsMenu.musicVolume));
#if android
			File.saveContent(SystemPath.applicationStorageDirectory + "/config.xml", config.toString());
#elseif flash
			Data.write("settings", config.toString());
			Data.save("mdt_data", true);
#else
			File.saveContent("config.xml", config.toString());
#end
		}
	}
}