package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.text.FlxTextField;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
using StringTools;

class PlayState extends FlxState
{
	private var _commandLine:FlxInputText;
	
	private var _grpPrevCommands:FlxTypedGroup<FlxText>;
	
	private var listCommands:Array<String> = 
	[
		"help"
	];
	
	private var stinky = "help";
	
	override public function create():Void
	{
		_commandLine = new FlxInputText(20, FlxG.height - 20, FlxG.width - 40, "", 16);
		add(_commandLine);
		
		_grpPrevCommands = new FlxTypedGroup<FlxText>();
		add(_grpPrevCommands);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (_commandLine.hasFocus && FlxG.keys.justPressed.ENTER)
		{
			commandParser(_commandLine.text);
			
			_commandLine.text = "";
			_commandLine.caretIndex = 0;
		}
	}
	
	private function commandParser(cmd:String):Void
	{
		cmd = cmd.toLowerCase();
		
		var commands = cmd.split(" ");
		var curCommand = commands[0];
		
		
		
		terminalAdd(cmd);
		
		switch(curCommand)
		{
			case "help":
				terminalAdd("help stuff lololol");
			default:
				terminalAdd(curCommand + " is not a recognized command... try 'help'");
		}			
	}
	
	private function terminalAdd(termString:String):Void
	{
		
		var newText:FlxText = new FlxText(_commandLine.x, 0, 0, termString, 16);
		newText.y = _commandLine.y - 20 * newText.textField.numLines;
		_grpPrevCommands.forEachAlive(function(t:FlxText){t.y -= 20 * newText.textField.numLines; });
		
		_grpPrevCommands.add(newText);
	}
}
