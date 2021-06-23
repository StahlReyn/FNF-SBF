package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		switch(char)
		{
			case 'sbf-bed':
				loadGraphic(Paths.image('iconSleep', 'spaceboy'), true, 150, 150);
				animation.add('sbf-bed', [0], 0, false, isPlayer);

			case 'sbf' | 'sbf-angry':
				loadGraphic(Paths.image('iconSB', 'spaceboy'), true, 150, 150);
				animation.add('sbf', [0, 1], 0, false, isPlayer);
				animation.add('sbf-angry', [2, 3], 0, false, isPlayer);
		
			default:
				loadGraphic(Paths.image('iconGrid'), true, 150, 150);
				animation.add('bf', [0, 1], 0, false, isPlayer);
				animation.add('gf', [16], 0, false, isPlayer);
		}
		animation.play(char);
		antialiasing = true;
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
