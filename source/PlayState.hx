package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.text.FlxTextField;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
using StringTools;

class PlayState extends FlxState
{
	private var _commandLine:FlxInputText;
	private var _grpPrevCommands:FlxTypedGroup<FlxText>;
	
	private var _txtTimer:FlxText;
	
	private var listCommands:Array<String> = 
	[
		"help"
	];
	

	private var stinky = "help";
	
	private var grpDrives:FlxTypedGroup<DriveSprite>;
	
	private var downloadTimer:Float = 0;
	private var timerNeeded:Float = 20;
	
	private var points:Float = 0;
	
	override public function create():Void
	{
		_commandLine = new FlxInputText(20, FlxG.height - 20, FlxG.width - 40, "", 16);
		_commandLine.font = "assets/data/CONSOLA.TTF";
		add(_commandLine);
		
		_grpPrevCommands = new FlxTypedGroup<FlxText>();
		add(_grpPrevCommands);
		
		grpDrives = new FlxTypedGroup<DriveSprite>();
		add(grpDrives);
		
		_txtTimer = new FlxText(20, 20, 0, "", 16);
		add(_txtTimer);
		
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
		
		downloadTimer = timerNeeded;
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		_txtTimer.text = FlxMath.roundDecimal(downloadTimer, 2) + "s until new downloads";
		
		downloadTimer -= elapsed;
		
		if (downloadTimer <= 0)
		{
			downloadFiles();
			timerNeeded *= 0.9;
			downloadTimer = timerNeeded;
		}
		
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
		
		
		
		terminalAdd(cmd, true);
		
		switch(curCommand)
		{
			case "help":
				terminalAdd("tutorial				- sends some game info");
				terminalAdd("credits				- shoutouts and also the goobers who made this game");
				terminalAdd("driveinfo				- gives you information for each installed drive");
				terminalAdd("eject <input>			- ejects the input drive, and re-inserts a new drive");
				terminalAdd("push <input> <output>	- moves every file from the input drive to the output drive");
				
			
			case "tutorial":
				terminalAdd("The game is controlled via the ingame command line only, use it to move around the data to keep it safe from the virus! Ejecting drives gets you points, but if there's virus bits in there you'll get a massive point deduction!");
			
			case "credits":
				creds();
			case "creds":
				creds();
			case "driveinfo":
				for (i in 0...grpDrives.members.length)
				{
					var driveKind:String = grpDrives.members[i].driveType;
					driveKind.toUpperCase();
					terminalAdd("Drive " + i + ": " + driveKind + " Usage: " + FlxMath.roundDecimal(grpDrives.members[i].curSize, 2) + "GB free of " + FlxMath.roundDecimal(grpDrives.members[i].maxCap, 2) + "GB");
				}
				
			case "push":
				var input:Int = Std.parseInt(commands[1]);
				var output:Int = Std.parseInt(commands[2]);
				// in this if, i use the Std.parseInt() function because it can also check if nulls and shit
				// whereas if I use input/outputDrive variables, I cant check for null
				if (Std.parseInt(commands[1]) != null && Std.parseInt(commands[2]) != null && FlxMath.inBounds(input, 0, grpDrives.length - 1) && FlxMath.inBounds(output, 0, grpDrives.length - 1))
				{
					var itemsMoved:Int = 0;
					// doin this while loop garbage because for some reason the forEach() function doesn't go through every item???
					var moveableItems:Int = grpDrives.members[input].grpFiles.length;
					while (moveableItems > 0)
					{
						grpDrives.members[input].grpFiles.forEachExists(function(s:FileSprite)
						{
							if (commands[3] == null)
							{
								grpDrives.members[output].grpFiles.add(s);
								grpDrives.members[input].grpFiles.remove(s, true);
								
								itemsMoved += 1;
							}
							else
							{
								if (s.fileType == commands[3])
								{
									grpDrives.members[output].grpFiles.add(s);
									grpDrives.members[input].grpFiles.remove(s, true);
									itemsMoved += 1;
								}
							}
							
							moveableItems -= 1;
						});
					}
					
					terminalAdd(itemsMoved + " items moved from drive " + input + " to drive " + output);
				}
				else
				{
					var drvJunk = grpDrives.length - 1;
					terminalAdd("Error in input, expects drive numbers between 0-" + drvJunk + " in parameters");
				}
			case "eject":
				var input:Int = Std.parseInt(commands[1]);
				if (Std.parseInt(commands[1]) != null && FlxMath.inBounds(input, 0, 2))
				{
					points += grpDrives.members[input].curSize;
					terminalAdd("Ejected drive " + input + " - " + grpDrives.members[input].curSize + "GB of data");
					
					var moveableItems:Int = grpDrives.members[input].grpFiles.length;
					while (moveableItems > 0)
					{
						grpDrives.members[input].grpFiles.forEachExists(function(s:FileSprite)
						{
							grpDrives.members[input].grpFiles.remove(s, true);
							
							moveableItems -= 1;
						});
					}
					
					grpDrives.members[input].driveType = FlxG.random.getObject(DriveSprite.driveTypes);
					
					new FlxTimer().start(FlxG.random.float(1, 4), 
										function(t:FlxTimer)
										{
											terminalAdd("Inserted an empty " + grpDrives.members[input].driveType + " in slot " + input + " with " + grpDrives.members[input].maxCap + "GB of free space");
										}, 1);
				}
				else
				{
					var drvJunk = grpDrives.length - 1;
					terminalAdd("Error in input, expects drive numbers between 0-" + drvJunk + " in input");
				}
			default:
				terminalAdd(curCommand + " is not a recognized command... try 'help'");
		}			
	}
	
	private function terminalAdd(termString:Dynamic, commandOverride:Bool = false):Void
	{
		if (commandOverride)
			termString = Std.string(termString);
		else
			termString = "\t" + Std.string(termString);
		
		
		var newText:FlxText = new FlxText(_commandLine.x, 0, FlxG.width - 20, termString, 16);
		newText.font = "assets/data/CONSOLA.TTF";
		newText.y = _commandLine.y - 20 * newText.textField.numLines;
		_grpPrevCommands.forEachAlive(function(t:FlxText){t.y -= 20 * newText.textField.numLines; });
		
		_grpPrevCommands.add(newText);
	}
	
	private function creds():Void
	{
		terminalAdd("Made by ninjamuffin99 and FuShark in 72 hours for Ludum Dare 42, 'Running Out Of Space'");
		terminalAdd("Design by ninjamuffin99 and FuShark");
		terminalAdd("Art: FuShark		Programming: ninjamuffin99");
		terminalAdd("Made with the HaxeFlixel framework: haxeflixel.com");
		terminalAdd("Game source code on github: github.com/ninjamuffin99/ld42");
		terminalAdd("Shoutouts to Newgrounds.com and i lov u tomfulp");
	}
	
	private function downloadFiles():Void
	{
		for (i in grpDrives.members)
		{
			var filesAmount = FlxG.random.int(0, 6);
			while (filesAmount > 0)
			{
				i.addFile(FlxG.random.getObject(DriveSprite.fileTypes));
				filesAmount -= 1;
			}
		}
	}
}
