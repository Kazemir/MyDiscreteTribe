package com.kazemir.mdt;

import com.haxepunk.HXP;
import com.haxepunk.Sfx;

class MusicManager
{
	public static var currentMusiuc:Sfx;
	
	private static var musicArray:Array<String> = ["music/SKOMOROSHIJ_BUNT_REVOLUTION_OF_CLOWNS_-_Melenka_Little_Mill__instrumental_.mp3", 
													"music/SKOMOROSHIJ_BUNT_REVOLUTION_OF_CLOWNS_-_Nebylitsy_Fables__instrumental_.mp3",
													"music/SKOMOROSHIJ_BUNT_REVOLUTION_OF_CLOWNS_-_Poljushko-Pole_A_Field__variant_.mp3",
													"music/SKOMOROSHIJ_BUNT_REVOLUTION_OF_CLOWNS_-_Russkaja_Narodnaja_Russian_Traditional.mp3"];
	private static var playedList:Array<Bool>;
	private var fade:Bool;
	private var fadeForGame:Bool;
	
	public function new() 
	{
		playedList = new Array<Bool>();
		
		for (i in 0...musicArray.length)
			playedList.push(false);
		
		fade = false;
		fadeForGame = true;
		
		currentMusiuc = new Sfx("music/SKOMOROSHIJ_BUNT_REVOLUTION_OF_CLOWNS_-_Naigrysh_Impromptu.mp3");
		currentMusiuc.loop(1, 0);
	}
	
	public function goGameMusic()
	{
		fade = true;
		fadeForGame = true;
	}
	
	public function goMenuMusic()
	{
		fade = true;
		fadeForGame = false;
	}
	
	public function stop()
	{
		currentMusiuc.stop();
	}
	
	private function ifMusicStops()
	{
		currentMusiuc.stop();
		var mus:String = "";
		var rnd:Int = HXP.rand(musicArray.length);
		var i:Int = 0;
		while (playedList[rnd] == true && i < 10)
		{
			rnd = HXP.rand(musicArray.length);
			i++;
		}
		if (playedList[rnd] == true)
		{
			i = playedList.indexOf(false);
			if (i == -1)
			{
				for (x in playedList)
				{
					x = false;
				}
				playedList[rnd] = true;
				mus = musicArray[rnd];
			}
			else
			{
				playedList[i] = true;
				mus = musicArray[i];
			}
		}
		else
		{
			playedList[rnd] = true;
			mus = musicArray[rnd];
		}
		
		currentMusiuc = new Sfx(mus, ifMusicStops);
		currentMusiuc.play(1, 0, false);
	}
	
	public function update()
	{
		if (fade)
		{
			currentMusiuc.volume -= 0.02;
			if (currentMusiuc.volume == 0)
			{
				fade = false;
				if (fadeForGame)
				{
					ifMusicStops();
				}
				else
				{
					currentMusiuc = new Sfx("music/SKOMOROSHIJ_BUNT_REVOLUTION_OF_CLOWNS_-_Naigrysh_Impromptu.mp3");
					currentMusiuc.loop(1, 0);
				}
			}
		}
	}
}