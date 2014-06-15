package com.kazemir.mdt.utils;

import com.kazemir.mdt.utils.CellularAutomata.PointInt;
import haxe.ds.Vector;

import com.haxepunk.HXP;
import com.haxepunk.Sfx;

import com.kazemir.mdt.screen.SettingsMenu;

//0 - ничего, 1 - игрок, 2 - племя, 3 - враги

class CellularAutomata
{
	public var matrix:Array<Array<Int>>;
	public var playerPos:PointInt;
	public var enemiesCampPos:PointInt;
	public var villagersCampPos:PointInt;
	
	private var width:Int;
	private var height:Int;
	
	private var iteration:Int;
	
	private var dificult:Int;//getTypeCount(new PointInt(i, j), 1) == 0
	
	public function new( width:Int, height:Int, dificult:Int = 0, startEnemies:Int = 9, startVillagers:Int = 5 ) 
	{
		this.width = width;
		this.height = height;
		this.dificult = dificult;
		
		iteration = 1;
		
		matrix = Array2D.create(width, height);
		
		playerPos = new PointInt(2 + 11 * HXP.rand(2), 2 + 11 * HXP.rand(2));
		villagersCampPos = playerPos.clone();
		enemiesCampPos = new PointInt(0, 0);
		
		if (playerPos.x == 2)
			enemiesCampPos.x = 13;
		else
			enemiesCampPos.x = 2;
		
		if (playerPos.y == 2)
			enemiesCampPos.y = 13;
		else
			enemiesCampPos.y = 2;
		
		matrix[playerPos.x][playerPos.y] = 1;

		for(x in 0...startEnemies)
			spawnType(enemiesCampPos, 3);
		for(x in 0...startVillagers)
			spawnType(villagersCampPos, 2);
	}
	
	public function nextTurn( direction:Int ):Bool
	{
		var thereIsSomeoneDied:Bool = false;
		var nextPlayerPos:PointInt = playerPos.clone();
		switch(direction)
		{
			case 0: //up
				nextPlayerPos.y--;
			case 1:	//right
				nextPlayerPos.x++;
			case 2:	//down
				nextPlayerPos.y++;
			case 3:	//left
				nextPlayerPos.x--;
		}
		if (nextPlayerPos.x < 0 || nextPlayerPos.x > 15 || nextPlayerPos.y < 0 || nextPlayerPos.y > 15)
			return false;
		
		if (matrix[nextPlayerPos.x][nextPlayerPos.y] != 0)
		{
			if (matrix[nextPlayerPos.x][nextPlayerPos.y] == 2)
				matrix[playerPos.x][playerPos.y] = 2;
			else
			{
				matrix[playerPos.x][playerPos.y] = 0;
				thereIsSomeoneDied = true;
			}
		}
		else
		{
			matrix[playerPos.x][playerPos.y] = 0;
		}
		
		matrix[nextPlayerPos.x][nextPlayerPos.y] = 1;
		playerPos = nextPlayerPos.clone();
		
		//движение каждого врага к ближе жителю
		for (i in 0...width)
		{
			for (j in 0...height)
			{
				if (matrix[i][j] == 3 && getTypeCount(new PointInt(i, j), 2) == 0 && getTypeCount(new PointInt(i, j), 0) > 0)
				{
					//spawnType(new PointInt(i, j), 4);
					var p:PointInt = nearestFreePos(new PointInt(i, j));
					matrix[p.x][p.y] = 4;
					matrix[i][j] = 0;
				}
			}
		}
		for (i in 0...width)
		{
			for (j in 0...height)
			{
				if (matrix[i][j] == 4)
					matrix[i][j] = 3;
			}
		}
		
		//ход всех остальных
		var newMatrix:Array<Array<Int>> = Array2D.create(width, height);
		for (i in 0...width)
		{
			for (j in 0...height)
			{
				if (matrix[i][j] == 0)
				{
					if (getTypeCount(new PointInt(i, j), 2) >= 3 && getTypeCount(new PointInt(i, j), 3) == 0 || getTypeCount(new PointInt(i, j), 2) > 1 && getTypeCount(new PointInt(i, j), 1) == 1)
						newMatrix[i][j] = 2;
					else
						newMatrix[i][j] = 0;
				}
				if (matrix[i][j] == 1)
					newMatrix[i][j] = 1;
				if (matrix[i][j] == 2)
				{
					if ((getTypeCount(new PointInt(i, j), 3) == 1 && getTypeCount(new PointInt(i, j), 2) < 5 || getTypeCount(new PointInt(i, j), 3) > 1) && getTypeCount(new PointInt(i, j), 1) == 0 || (getTypeCount(new PointInt(i, j), 2) > 7 && dificult >= 1))
					{
						newMatrix[i][j] = 0;
						thereIsSomeoneDied = true;
					}
					else
						newMatrix[i][j] = 2;
				}
				if (matrix[i][j] == 3)
				{
					if (getTypeCount(new PointInt(i, j), 2) >= 7)
					{
						newMatrix[i][j] = 0;
						thereIsSomeoneDied = true;
					}
					else
						newMatrix[i][j] = 3;
				}
			}
		}
		
		matrix = newMatrix.copy();
		
		//спавн врага каждые четыре хода
		if (iteration % 4 == 0 && newMatrix[enemiesCampPos.x][enemiesCampPos.y] != 1)
			spawnType(enemiesCampPos, 3);
			//newMatrix[enemiesCampPos.x][enemiesCampPos.y] = 3;
		
		if (thereIsSomeoneDied)
		{
#if !flash
			var st:Sfx = new Sfx("sounds/dead.wav");
#else
			var st:Sfx = new Sfx("sounds/dead.mp3");
#end
			st.play(SettingsMenu.soudVolume / 10, 0, false);
		}
		
		iteration++;
		return true;
	}
	
	private function nearestFreePos( point:PointInt ):PointInt
	{
		var p:PointInt = new PointInt(0, 0);
		var isIT:Bool = false;
		while (!isIT)
		{
			switch(HXP.rand(8))
			{
				case 0:
					p = new PointInt(point.x - 1, point.y);
				case 1:
					p = new PointInt(point.x, point.y - 1);
				case 2:
					p = new PointInt(point.x + 1, point.y);
				case 3:
					p = new PointInt(point.x, point.y + 1);
				case 4:
					p = new PointInt(point.x - 1, point.y - 1);
				case 5:
					p = new PointInt(point.x + 1, point.y - 1);
				case 6:
					p = new PointInt(point.x + 1, point.y + 1);
				case 7:
					p = new PointInt(point.x - 1, point.y + 1);
			}
			if (p.x < 0 || p.y < 0 || p.x > 15 || p.y > 15)
				isIT = false;
			else if (matrix[p.x][p.y] == 0)
				isIT = true;
		}
		return p;
	}
	
	private function spawnType(point:PointInt, type:Int ):Bool
	{
		if (matrix[point.x][point.y] == 0)
			matrix[point.x][point.y] = type;
		else if (matrix[point.x - 1][point.y] == 0)
			matrix[point.x - 1][point.y] = type;
		else if (matrix[point.x][point.y - 1] == 0)
			matrix[point.x][point.y - 1] = type;
		else if (matrix[point.x + 1][point.y] == 0)
			matrix[point.x + 1][point.y] = type;
		else if (matrix[point.x][point.y + 1] == 0)
			matrix[point.x][point.y + 1] = type;
		else if (matrix[point.x - 1][point.y - 1] == 0)
			matrix[point.x - 1][point.y - 1] = type;
		else if (matrix[point.x + 1][point.y - 1] == 0)
			matrix[point.x + 1][point.y - 1] = type;
		else if (matrix[point.x + 1][point.y + 1] == 0)
			matrix[point.x + 1][point.y + 1] = type;
		else if (matrix[point.x - 1][point.y + 1] == 0)
			matrix[point.x - 1][point.y + 1] = type;
		else
			return false;
		return true;
	}
	
	private function getTypeCount( point:PointInt, type:Int )
	{
		var count:Int = 0;
		
		if (point.x > 0 && matrix[point.x - 1][point.y] == type)
			count++;
		if (point.x < width - 1 && matrix[point.x + 1][point.y] == type)
			count++;
		if (point.y > 0 && matrix[point.x][point.y - 1] == type)
			count++;
		if (point.y < height - 1 && matrix[point.x][point.y + 1] == type)
			count++;
			
		if (point.x > 0 && point.y > 0 && matrix[point.x - 1][point.y - 1] == type)
			count++;
		if (point.x < width - 1 && point.y > 0 && matrix[point.x + 1][point.y - 1] == type)
			count++;
		if (point.x < width - 1 && point.y < height - 1 && matrix[point.x + 1][point.y + 1] == type)
			count++;
		if (point.x > 0 && point.y < height - 1 && matrix[point.x - 1][point.y + 1] == type)
			count++;
		
		return count;
	}
}


class Array2D
{
    public static function create(w:Int, h:Int)
    {
        var a = [];
        for (x in 0...w)
        {
            a[x] = [];
            for (y in 0...h)
            {
                a[x][y] = 0;
            }
        }
        return a;
    }
} 

class PointInt
{
	public var x:Int;
	public var y:Int;
	
    public function new( x:Int, y:Int )
    {
        this.x = x;
		this.y = y;
    }
	
	public function clone():PointInt 
	{
		return new PointInt(x, y);
	}

} 