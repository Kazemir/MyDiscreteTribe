package com.kazemir.mdt.utils;

import haxe.ds.Vector;

import com.haxepunk.HXP;

//0 - ничего, 1 - игрок, 2 - племя, 3 - враги

class CellularAutomata
{
	public var matrix:Array<Array<Int>>;
	
	public function new( width:Int, height:Int ) 
	{
		for (i in 0...16)
		{
			for (j in 0...16)
			{
				matrix[i][j] = HXP.rand(4);
			}
		}
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