package com.kazemir.mdt.screen;

import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Screen extends Scene
{

	public function new() 
	{
		super();
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
	}
}