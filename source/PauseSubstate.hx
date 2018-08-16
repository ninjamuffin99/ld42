package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class PauseSubstate extends FlxSubState 
{
	
	private var bg:FlxSprite;
	private var bg2:FlxSprite;
	
	private var curSelected:Int = 0;
	private var selectCursor:FlxText;
	
	private var menuItems:Array<String> = 
	[
		"CONTINUE",
		"RETRY",
		"QUIT"
	];
	
	private var grpMenu:FlxTypedGroup<FlxSprite>;

	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		bg = new FlxSprite().loadGraphic(AssetPaths.DED_DRIVE_PAUSE_Overlay__png);
		add(bg);
		
		bg.alpha = 0;
		
		FlxTween.tween(bg, {alpha: 1}, 0.5, {ease:FlxEase.quintOut});
		
		bg2 = new FlxSprite(0, bg.height).loadGraphic(AssetPaths.DED_DRIVE_PAUSE_Overlay__png);
		add(bg2);
		bg2.alpha = 0;
		
		grpMenu = new FlxTypedGroup<FlxSprite>();
		add(grpMenu);
		
		for (i in 0...menuItems.length)
		{
			var textItem:FlxText = new FlxText(0, 270 + (i * 30), 0, menuItems[i], 15);
			textItem.font = AssetPaths.CONSOLA__TTF;
			textItem.screenCenter(X);
			grpMenu.add(textItem);
		}
		
		selectCursor = new FlxText(0, 0, 0, ">", 16);
		selectCursor.font = AssetPaths.CONSOLA__TTF;
		add(selectCursor);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		bg2.alpha = bg.alpha;
		
		if (FlxG.keys.justPressed.DOWN)
		{
			curSelected += 1;
			FlxG.sound.play(AssetPaths.keyClickOn4__mp3);
		}
		if (FlxG.keys.justPressed.UP)
		{
			curSelected -= 1;
			FlxG.sound.play(AssetPaths.keyClickOn1__mp3);
		}
		
		if (curSelected > menuItems.length - 1)
		{
			curSelected = 0;
		}
		if (curSelected < 0)
		{
			curSelected = menuItems.length - 1;
		}
		
		selectCursor.x = grpMenu.members[curSelected].x - 20;
		selectCursor.y = grpMenu.members[curSelected].y;
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			
			close();
		}
		
		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
		{
			switch (curSelected)
			{
				case 0:
					close();
				case 1:
					FlxG.camera.fade(FlxColor.BLACK, 0.6, false, function(){FlxG.resetState(); });
				case 2:
					// return to title screen
			}
		}
		
		super.update(elapsed);
	}
	
	override public function close():Void 
	{
		FlxG.sound.music.fadeIn(0.4, 0.35);
		
		super.close();
	}
	
}