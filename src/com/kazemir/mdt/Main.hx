package com.kazemir.mdt;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.kazemir.mdt.screen.SplashScreen;

class Main extends Engine
{
	public function new()
	{
		super(800, 600, 30, true, RenderMode.HARDWARE);
	}
	
	override public function init()
	{
#if debug
		HXP.console.enable();
		HXP.console.log(["The game has started!"]);
#end
		HXP.scene = new SplashScreen();
	}

	public static function main() 
	{ 
		new Main(); 
	}
	
	override public function focusLost () 
	{
		paused = true;
	}
	
	override public function focusGained () 
	{
		paused = false;
	}

}