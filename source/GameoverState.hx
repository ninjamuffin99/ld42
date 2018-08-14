package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class GameoverState extends FlxState 
{

	override public function create():Void 
	{
		FlxG.camera.bgColor = FlxColor.BLUE;
		
		var txtDead:FlxText = new FlxText(0, 0, 0, "RIP PC LOL U DUMMY\nPRESS ENTER TO BUY A NEW PC IDIOT", 38);
		txtDead.screenCenter();
		add(txtDead);
		
		var txtScore:FlxText = new FlxText(0, FlxG.height * 0.7, 0, "You got " + PlayState.points + "GB of data uploaded before you crashed and killed your PC", 16);
		txtScore.screenCenter(X);
		add(txtScore);
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(new PlayState());
		
		super.update(elapsed);
	}
	
}