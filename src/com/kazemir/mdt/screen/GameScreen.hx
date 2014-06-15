package com.kazemir.mdt.screen;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

import com.kazemir.mdt.box.GameMenu;
import com.kazemir.mdt.utils.CellularAutomata;
import com.kazemir.mdt.utils.TileGrid;
import com.kazemir.mdt.box.YesNoBox;

class GameScreen extends Screen
{
	private var tileGrid:TileGrid;
	private var characterGrid:TileGrid;
	private var cellularAutomata:CellularAutomata;
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
				var rand:Float = HXP.random;
				if (rand < 0.5)
				{
					tileGrid.addTile(i, j, 0, false);
				}
				else
					tileGrid.addTile(i, j, HXP.rand(8) + 1, false);
			}
		}
		add(tileGrid);
		
		cursor = new Image("graphics/cursor.png");
		cursor.x = 0;
		cursor.y = 0;
		addGraphic(cursor, -2);
		
		cellularAutomata = new CellularAutomata(16, 16);
		
		characterGrid = new TileGrid(144, 70, 16, 16, 32, 32, "graphics/characters.png", -1);
		add(characterGrid);
		
		updateGraphic();
	}
	
	private function updateGraphic()
	{
		var numberOfVillagers:Int = 0;
		var numberOfEnemies:Int = 0;
		
		for (i in 0...16)
		{
			for (j in 0...16)
			{
				characterGrid.tileMap.clearTile(i, j);
				if (cellularAutomata.matrix[i][j] != 0)
				{
					if (cellularAutomata.matrix[i][j] == 1)
					{
						cursor.x = 144 + i * 32;
						cursor.y = 70 + j * 32;
						characterGrid.tileMap.setTile(i, j, 0);
					}
					if (cellularAutomata.matrix[i][j] == 2)
					{
						numberOfVillagers++;
						characterGrid.tileMap.setTile(i, j, 2);
					}
					if (cellularAutomata.matrix[i][j] == 3)
					{
						numberOfEnemies++;
						characterGrid.tileMap.setTile(i, j, 1);
					}
				}
			}
		}
		
		var sndStr:String = "";
#if !flash
		if (HXP.random < 0.5)
			sndStr = "sounds/step.wav";
		else
			sndStr = "sounds/step2.wav";
#else
		if (HXP.random < 0.5)
			sndStr = "sounds/step.mp3";
		else
			sndStr = "sounds/step2.mp3";
#end
		var st:Sfx = new Sfx(sndStr);
		st.play(SettingsMenu.soudVolume / 10, 0, false);
		
		if (numberOfEnemies == 0)
		{
			var ynB:YesNoBox = new YesNoBox(HXP.halfWidth, HXP.halfHeight, "ПОБЕДА!", "Ваша братия прогнала всю нечисть съ близлежащихъ земель! Начать игру заново?", 1);
			add(ynB);
		}
		if (numberOfVillagers == 0)
		{
			var ynB:YesNoBox = new YesNoBox(HXP.halfWidth, HXP.halfHeight, "ПОРАЖЕНИЕ...", "Вы не сберегли свою дружину... Начать игру заново?", 1);
			add(ynB);
		}
	}

	public override function update()
	{
		if ((Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B")) && !Screen.overrideControlByBox)
		{
			var gM:GameMenu = new GameMenu(HXP.halfWidth, HXP.halfHeight);
			add(gM);
		}
		if ((Input.pressed("up") || Screen.joyPressed("DPAD_UP")) && !Screen.overrideControlByBox)
		{
			if(cellularAutomata.nextTurn(0))
				updateGraphic();
		}
		if ((Input.pressed("down") || Screen.joyPressed("DPAD_DOWN")) && !Screen.overrideControlByBox)
		{
			if(cellularAutomata.nextTurn(2))
				updateGraphic();
		}
		if ((Input.pressed("left") || Screen.joyPressed("DPAD_LEFT")) && !Screen.overrideControlByBox)
		{
			if(cellularAutomata.nextTurn(3))
				updateGraphic();
		}
		if ((Input.pressed("right") || Screen.joyPressed("DPAD_RIGHT")) && !Screen.overrideControlByBox)
		{
			if(cellularAutomata.nextTurn(1))
				updateGraphic();
		}
		
		super.update();
	}
}