package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class InfoSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"This mod is still in the making!\n"
			+ "There will be cutscenes, more song, and a proper ending!\n"
			+ "Just thought i would be wiser to put the base stuff out\n"
			+ "So I can improve it better from proper critcism.\n"
			+ "Press ANY KEY to continue!",
			32);
		//txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.setFormat(Paths.font("OMORI_GAME2.ttf"), 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ANY)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
