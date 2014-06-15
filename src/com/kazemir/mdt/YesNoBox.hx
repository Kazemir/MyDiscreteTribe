package com.kazemir.mdt;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.utils.Input;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;

import com.kazemir.mdt.DrawText;
import com.kazemir.mdt.screen.Screen;
import com.kazemir.mdt.screen.MenuScreen;

class YesNoBox extends Entity
{
	public var captionText:DrawText;
	public var messageText:DrawText;
	public var yesNoText:DrawText;
	
	private static var minW:Int = 300;
	
	public function new(x:Float=0, y:Float=0, caption:String, message:String) 
	{
		super(x, y);
		
		var sprite:Sprite = new Sprite();
        var g:Graphics = sprite.graphics;
		
		captionText = new DrawText(caption, GameFont.Tsarevich, 28, 150, 17, 0, true);
		
		var frameW:Int = minW;
		if (captionText.label.width + 10 > minW)
			frameW = captionText.label.width + 10;
			
		captionText.label.x = frameW / 2;
		
		messageText = new DrawText(message, GameFont.TriodPostnaja, 16, 5, 28, 0, false, frameW - 10, 0);
		
		var msgFrameH:Int = messageText.label.textHeight;
		
		g.beginFill(0);
		g.drawRoundRect(0, 0, frameW, 28 + msgFrameH + 4 + 25, 0);
		g.endFill();
		g.beginFill(0xad1e1e);
		g.drawRoundRect(1, 1, frameW - 2, 28 + msgFrameH + 2 + 25, 0);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(2, 2, frameW - 4, 24, 0);
		g.endFill();
		g.beginFill(0xe6e3c4);
		g.drawRoundRect(3, 3, frameW - 6, 22, 0);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(2, 27, frameW - 4, msgFrameH + 3, 0);
		g.endFill();
		g.beginFill(0xe6e3c4);
		g.drawRoundRect(3, 28, frameW - 6, msgFrameH + 1, 0);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(2, 28 + msgFrameH + 3, frameW - 4, 24, 0);
		g.endFill();
		g.beginFill(0xe6e3c4);
		g.drawRoundRect(3, 28 + msgFrameH + 4, frameW - 6, 22, 0);
		g.endFill();
		
		yesNoText = new DrawText("ДА - ENTER, НЕТ - ESC", GameFont.TriodPostnaja, 16, frameW / 2, 28 + msgFrameH + 14, 0, true);
		
		var img:BitmapData = new BitmapData(frameW, 28 + msgFrameH + 4 + 25, true, 0xe6e3c4);
		img.draw(sprite);
		
		graphic = new Stamp(img);
		graphic.scrollX = graphic.scrollY = 0;
		
		addGraphic(captionText.label);
		addGraphic(messageText.label);
		addGraphic(yesNoText.label);
		captionText.label.scrollX = captionText.label.scrollY = 0;
		messageText.label.scrollX = messageText.label.scrollY = 0;
		yesNoText.label.scrollX = yesNoText.label.scrollY = 0;
		
		graphic.x -= frameW / 2;
		graphic.y -= 16 + msgFrameH / 2;
		
		layer = -50;
		
		Screen.overrideControlByBox = true;
	}
	
	public override function update()
	{
		super.update();
		
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B"))
		{
			Screen.overrideControlByBox = false;
			this.scene.remove(this);
		}
		if (Input.pressed("action") || Screen.joyPressed("A"))
		{
			Screen.overrideControlByBox = false;
			this.scene.remove(this);
			Screen.music.goMenuMusic();
			HXP.scene = new MenuScreen();
		}
	}
	
}