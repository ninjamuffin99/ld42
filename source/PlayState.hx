package;

import flixel.FlxG;
import flixel.FlxSprite;
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
	
	private var grpDrives:FlxTypedGroup<DriveSprite>;
	
	
	
	override public function create():Void
	{
		_commandLine = new FlxInputText(20, FlxG.height - 20, FlxG.width - 40, "", 16);
		_commandLine.font = "assets/data/CONSOLA.TTF";
		add(_commandLine);
		
		_grpPrevCommands = new FlxTypedGroup<FlxText>();
		add(_grpPrevCommands);
		
		grpDrives = new FlxTypedGroup<DriveSprite>();
		add(grpDrives);
		
		var driveCount:Int = 0;
		
		var driveTypes = ["ssd", "hdd", "usb"];
		while (driveCount < 3)
		{
			var newDrive:DriveSprite = new DriveSprite(FlxG.width / 3 * driveCount, 0, FlxG.random.getObject(driveTypes));
			grpDrives.add(newDrive);
			
			driveCount += 1;
			
			var randoFiles:Int = FlxG.random.int(1, 6);
			while (randoFiles > 0)
			{
				newDrive.addFile(FlxG.random.getObject(DriveSprite.fileTypes));
				randoFiles -= 1;
			}
		}
		
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
			case "driveinfo":
				for (i in 0...grpDrives.members.length)
				{
					var driveKind:String = grpDrives.members[i].driveType;
					driveKind.toUpperCase();
					terminalAdd("Drive " + i + ": " + driveKind);
					terminalAdd("Max Capacity: " + grpDrives.members[i].maxCap + "GB\n");
				}
			case "push":
				var input:Int = Std.parseInt(commands[1]) - 1;
				var output:Int = Std.parseInt(commands[2]) - 1;
				// in this if, i use the Std.parseInt() function because it can also check if nulls and shit
				// whereas if I use input/outputDrive variables, I cant check for null
				if (Std.parseInt(commands[1]) != null && Std.parseInt(commands[2]) != null)
				{
					var itemsMoved:Int = 0;
					// doin this while loop garbage because for some reason the forEach() function doesn't go through every item???
					while (grpDrives.members[input].grpFiles.length > 0)
					{
						grpDrives.members[input].grpFiles.forEachExists(function(s:FlxSprite)
						{
							grpDrives.members[output].grpFiles.add(s);
							grpDrives.members[input].grpFiles.remove(s, true);
							
							itemsMoved += 1;
							
						});
					
					}
					
					var shit:Int = 0;
					terminalAdd(grpDrives.members[input].filesArray[0].length);
					for (i in 0...grpDrives.members[input].filesArray[0].length)
					{
						shit += 1;
						
						grpDrives.members[output].filesArray[0].push(grpDrives.members[input].filesArray[0][i - 1]);
						grpDrives.members[output].filesArray[0].push(grpDrives.members[input].filesArray[1][i - 1]);
					}
					
					grpDrives.members[input].filesArray[0] = [];
					grpDrives.members[input].filesArray[1] = [];
					
					
					terminalAdd(itemsMoved + " items moved from drive " + input + " to drive " + output);
					terminalAdd(shit + " from drive " + input + " to drive " + output);
				}
				else
				{
					terminalAdd("Error in input, expects drive numbers between 1-3 in parameters");
				}
			default:
				terminalAdd(curCommand + " is not a recognized command... try 'help'");
		}			
	}
	
	private function terminalAdd(termString:Dynamic):Void
	{
		termString = Std.string(termString);
		
		var newText:FlxText = new FlxText(_commandLine.x, 0, 0, termString, 16);
		newText.font = "assets/data/CONSOLA.TTF";
		newText.y = _commandLine.y - 20 * newText.textField.numLines;
		_grpPrevCommands.forEachAlive(function(t:FlxText){t.y -= 20 * newText.textField.numLines; });
		
		_grpPrevCommands.add(newText);
	}
}
