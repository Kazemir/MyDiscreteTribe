package com.kazemir.mdt.utils;

import haxe.ds.Vector;

import com.haxepunk.HXP;

//0 - ничего, 1 - игрок, 2 - племя, 3 - враги

class CellularAutomata
{
	public var matrix:Array<Array<Int>>;
	public var playerPos:PointInt;
	public var enemiesCampPos:PointInt;
	
	public function new( width:Int, height:Int, startEnemies:Int = 5, startVillagers:Int = 5 ) 
	{
		matrix = Array2D.create(width, height);
		
		var leftEnemies:Int = startEnemies;
		var leftVillagers:Int = startVillagers;
		
		playerPos = new PointInt(2 + 11 * HXP.rand(2), 2 + 11 * HXP.rand(2));
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
		matrix[enemiesCampPos.x][enemiesCampPos.y] = 3;
	}
	
	public function nextTurn( direction:Int ):Bool
	{
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
				matrix[playerPos.x][playerPos.y] = 0;
		}
		else
		{
			matrix[playerPos.x][playerPos.y] = 0;
		}
		
		matrix[nextPlayerPos.x][nextPlayerPos.y] = 1;
		playerPos = nextPlayerPos.clone();
		
		//ход всех остальных
		
		return true;
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