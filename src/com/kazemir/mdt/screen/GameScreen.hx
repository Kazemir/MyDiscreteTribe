package com.kazemir.mdt.screen;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

import com.kazemir.mdt.box.GameMenu;
import com.kazemir.mdt.utils.CellularAutomata;
import com.kazemir.mdt.utils.TileGrid;
import com.kazemir.mdt.box.YesNoBox;

class GameScreen extends Screen
{
	private var tileGrid:TileGrid;
	private var cellularAutomata:CellularAutomata;
	private var characterList:Graphiclist;
	private var cursor:Image;
	
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
		
		var img:Image = new Image("graphics/gameScreen.png");
		addGraphic(img);
		
		tileGrid = new TileGrid(144, 70, 16, 16, 32, 32, "graphics/tiles.png", 0);
		for (i in 0...16)
		{
			for (j in 0...16)
			{
				tileGrid.addTile(i, j, HXP.rand(9), false);
			}
		}
		add(tileGrid);
		
		cellularAutomata = new CellularAutomata(16, 16);
		
		for (i in 0...16)
		{
			for (j in 0...16)
			{
				if (cellularAutomata.matrix[i][j] != 0)
				{
					var aaa:Spritemap = new Spritemap("graphics/characters.png", 32, 32);
					if (cellularAutomata.matrix[i][j] == 1)
					{
						addGraphic(new Image("graphics/cursor.png"), -2, 144 + i * 32, 70 + j * 32);
						aaa.setFrame(0, 0);
					}
					if(cellularAutomata.matrix[i][j] == 2)
						aaa.setFrame(2, 0);
					if(cellularAutomata.matrix[i][j] == 3)
						aaa.setFrame(1, 0);
					//characterList.add(
					addGraphic(aaa, -1, 144 + i * 32, 70 + j * 32);
				}
			}
		}
	}
	
	public override function update()
	{
		if ((Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B")) && !Screen.overrideControlByBox)
		{
			var gM:GameMenu = new GameMenu(HXP.halfWidth, HXP.halfHeight);
			add(gM);
		}
		if (Input.pressed("up") || Screen.joyPressed("DPAD_UP"))
		{
			//currentMenuElement--;
		}
		if (Input.pressed("down") || Screen.joyPressed("DPAD_DOWN"))
		{
			//currentMenuElement++;
		}
		if (Input.pressed("left") || Screen.joyPressed("DPAD_LEFT"))
		{
			//actionMenu(false);
		}
		if (Input.pressed("right") || Screen.joyPressed("DPAD_RIGHT"))
		{
			//actionMenu(true);
		}
		
		super.update();
	}
}