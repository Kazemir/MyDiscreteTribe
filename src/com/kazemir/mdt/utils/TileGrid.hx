package com.kazemir.mdt.utils;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;
import com.haxepunk.masks.SlopedGrid;

class TileGrid extends Entity
{
	public var tileMap:Tilemap;
	public var collideGrid:Grid; 
	
	public function new( x:Float, y:Float, width:Int, height:Int, tileWidth:Int, tileHeight:Int, tileset:String, layer:Int ) 
	{
		tileMap = new Tilemap(tileset, width * tileWidth, height * tileHeight, tileWidth, tileHeight, 0, 0);
		collideGrid = new Grid(tileMap.width, tileMap.height, tileMap.tileWidth, tileMap.tileHeight, 0, 0);

		super(x, y, tileMap , collideGrid);
		
		type = "solid";
		this.layer = layer;
	}
	
	public function addTile(x:Int, y:Int, index:Int, solid:Bool = true)
	{
		tileMap.setTile(x, y, index);
		collideGrid.setTile(x, y, solid);
	}
	
	public function getTile(x:Int, y:Int):Int
	{
		return tileMap.getTile(x, y);
	}
	
	public function getTileCollidability(x:Int, y:Int):Bool
	{
		return collideGrid.getTile(x, y);
	}
	
	public override function update()
	{
		super.update();
	}
}