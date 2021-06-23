package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var dialogueBox:FlxSprite;
	var rightBox:FlxSprite;
	var leftBox:FlxSprite;
	var bfFace:FlxSprite;
	var allowDadPortrait:Bool = false;
	var allowBfPortrait:Bool = false;

	var curCharacter:String = '';
	var curPortrait:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'i-want-nothing-more':
				FlxG.sound.playMusic(Paths.music('sbf_lovesick'), 0);
				FlxG.sound.music.fadeIn(0.5, 0, 0.7);
			case 'three-bar-logos':
				FlxG.sound.playMusic(Paths.music('sbf_trouble'), 0);
				FlxG.sound.music.fadeIn(0.5, 0, 0.7);
			case 'you-were-wrong-go-back':
				FlxG.sound.playMusic(Paths.music('sbf_trouble'), 0);
				FlxG.sound.music.fadeIn(0.5, 0, 0.7);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		dialogueBox = new FlxSprite(-20, 45);
		dialogueBox.antialiasing = false;
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{		
			case 'i-want-nothing-more':
				hasDialog = true;
			case 'three-bar-logos':
				hasDialog = true;
			case 'you-were-wrong-go-back':
				hasDialog = true;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		//make box flat, replaces normal open
		dialogueBox = new FlxSprite(380, 470).loadGraphic(Paths.image('UI/dialogueBox', 'cutscene'));
		dialogueBox.visible = false;
		dialogueBox.scale.x = 2;
		dialogueBox.scale.y = 2;
		dialogueBox.updateHitbox();
		dialogueBox.screenCenter(X);
		dialogueBox.updateHitbox();
		add(dialogueBox);

		//bf right side, changing scale and then update the hitbox and set the scale back
		rightBox = new FlxSprite(1000, 280).loadGraphic(Paths.image('UI/portraitBox', 'cutscene'));
		rightBox.scale.x = 1.5;
		rightBox.scale.y = 1.5;
		rightBox.updateHitbox();
		rightBox.screenCenter(X);
		rightBox.x += 350;
		rightBox.updateHitbox();
		//rightBox.x = dialogueBox.x + dialogueBox.width - rightBox.width;
		//rightBox.y = dialogueBox.y - (dialogueBox.width * 1.1);
		rightBox.visible = false;
		add(rightBox);

		//dad left side
		leftBox = new FlxSprite(230, 280).loadGraphic(Paths.image('UI/portraitBox', 'cutscene'));
		leftBox.scale.x = 1.5;
		leftBox.scale.y = 1.5;
		rightBox.updateHitbox();
		leftBox.screenCenter(X);
		leftBox.x -= 385;
		leftBox.updateHitbox();
		leftBox.visible = false;
		add(leftBox);

		allowDadPortrait = false;
		allowBfPortrait = false;

		//portrait for first time edge case lol
		bfFace = new FlxSprite(rightBox.x, rightBox.y).loadGraphic(Paths.image('portraits/bfPortrait', 'cutscene'));
		bfFace.visible = false;
		add(bfFace);

		handSelect = new FlxSprite(dialogueBox.x + dialogueBox.width * 0.9, dialogueBox.y + dialogueBox.height * 0.9).loadGraphic(Paths.image('UI/hand_textbox', 'cutscene'));
		handSelect.antialiasing = false;
		add(handSelect);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.setFormat(Paths.font("OMORI_GAME2.ttf"), 48, FlxColor.WHITE, LEFT);
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('omoriText'), 0.6)];
		add(swagDialogue);

		// set them all flat for later tweening
		dialogueBox.scale.y = 0;
		rightBox.scale.y = 0;
		leftBox.scale.y = 0;

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		//open dialogue box
		if (!dialogueBox.visible && !dialogueStarted)
			{
			dialogueBox.visible = true;
			FlxTween.tween(dialogueBox, {"scale.y": 1.8}, 0.5, {
				ease: FlxEase.quartOut, 
				onComplete: function(twn:FlxTween)
					{
						dialogueOpened = true;
					}});
			}

		//start dialogue
		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'i-want-nothing-more' || PlayState.SONG.song.toLowerCase() == 'three-bar-logos')
						FlxG.sound.music.fadeOut(1.5, 0);

					//close dialogue
					FlxTween.tween(dialogueBox, {"scale.y": 0}, 0.7, {
						ease: FlxEase.quartOut, 
						onComplete: function(twn:FlxTween)
							{
								dialogueBox.visible = false;
							}});
					FlxTween.tween(rightBox, {"scale.y": 0}, 0.7, {
						ease: FlxEase.quartOut, 
						onComplete: function(twn:FlxTween)
							{
								rightBox.visible = false;
							}});
					FlxTween.tween(leftBox, {"scale.y": 0}, 0.7, {
						ease: FlxEase.quartOut, 
						onComplete: function(twn:FlxTween)
							{
								leftBox.visible = false;
							}});
					FlxTween.tween(bgFade, {alpha: 0}, 0.7, {ease: FlxEase.quartOut});
					FlxTween.tween(swagDialogue, {alpha: 0}, 0.7, {ease: FlxEase.quartOut});
					bfFace.visible = false;

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		//so the last one doesn't hang over
		remove(bfFace);
		//determining which portrait
		bfFace = new FlxSprite(rightBox.x, rightBox.y).loadGraphic(Paths.image(('portraits/$curPortrait'), 'cutscene'));
		bfFace.visible = false;
		//set size and hitbox
		bfFace.setGraphicSize(Std.int(rightBox.width * 0.9), Std.int(rightBox.height * 0.9));
		bfFace.updateHitbox();
		add(bfFace);

		switch (curCharacter)
		{
			case 'dad':
				rightBox.visible = false;

				bfFace.x = leftBox.x + ((leftBox.width - bfFace.width) / 2);
				bfFace.y = leftBox.y + ((leftBox.height - bfFace.height) / 2);

				if (!leftBox.visible)
				{
					leftBox.visible = true;
					if (!allowDadPortrait)
					{
						FlxTween.tween(leftBox, {"scale.y": 1.5}, 0.2, {
							ease: FlxEase.quartOut,
							onComplete: function(twn:FlxTween)
								{
									allowDadPortrait = true;
									bfFace.visible = true;
								}
							}
						);
					}
				}
				//appearing for rest of the times
				if (allowDadPortrait)
					{
						bfFace.visible = true;
					}

			case 'bf':
				leftBox.visible = false;

				bfFace.x = rightBox.x + ((rightBox.width - bfFace.width) / 2);
				bfFace.y = rightBox.y + ((rightBox.height - bfFace.height) / 2);
				//flip because it's the other side
				bfFace.flipX = true;
	
				//actual face appearing for first time
				if (!rightBox.visible)
				{
					rightBox.visible = true;
					if (!allowBfPortrait)
					{
						FlxTween.tween(rightBox, {"scale.y": 1.5}, 0.2, {
							ease: FlxEase.quartOut,
							onComplete: function(twn:FlxTween)
								{
									allowBfPortrait = true;
									bfFace.visible = true;
								}
							}
						);
					}
				}
				//appearing for rest of the times
				if (allowBfPortrait)
					{
						bfFace.visible = true;
					}
		}
		/*switch (curPortrait)
		{
			default:
				bfFace = FlxSprite(rightBox.x, rightBox.y).loadGraphic(Paths.image('UI/bfPortrait', 'cutscene'));
		}*/
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		curPortrait = splitName[2];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[2].length + 3).trim();
		
		//if its blank set it to default portrait
		if (curPortrait == "")
			curPortrait = "bfPortrait";
	}
}
