package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.plugin.screengrab.FlxScreenGrab;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
using StringTools;

class PlayState extends FlxState
{
	private var _commandLine:FlxInputText;
	private var _grpPrevCommands:FlxTypedGroup<FlxText>;
	
	private var _txtTimer:FlxText;
	
	private var listCommands:Array<String> = 
	[
		""
	];
	
	private var commandHistory:Int = -1;
	

	private var stinky = "help";
	
	private var grpDrives:FlxTypedGroup<DriveSprite>;
	
	private var downloadTimer:Float = 0;
	private var virusTimer:Float = 15;
	private var virusTimerNeeded:Float = 15;
	private var timerNeeded:Float = 20;
	
	private var virusDrive:Int = 0;
	private var bombSprite:FlxSprite;
	private var bombCountdown:FlxText;
	
	private var cooldown:Float = 0;
	
	private var points:Float = 0;
	
	override public function create():Void
	{
		FlxG.camera.bgColor = 0xFF53575d;
		
		var cmdBG:FlxSprite = new FlxSprite(0, 410).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(cmdBG);
		
		_commandLine = new FlxInputText(20, FlxG.height - 31, FlxG.width - 40, "", 16, FlxColor.WHITE);
		_commandLine.font = "assets/data/CONSOLA.TTF";
		_commandLine.background = false;
		_commandLine.caretWidth = 3;
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
			var newDrive:DriveSprite = new DriveSprite(FlxG.width / 3 * driveCount, 0, FlxG.random.getObject(driveTypes, [0.9, 0.4, 0.4]));
			grpDrives.add(newDrive);
			
			
			newDrive.addFile("os");
			FlxGridOverlay.overlay(newDrive.grpFiles.members[0], 10, 10);
			
			var randoFiles:Int = FlxG.random.int(1, 6);
			while (randoFiles > 0)
			{
				newDrive.addFile(FlxG.random.getObject(DriveSprite.fileTypes, [1, 1, 0, 1]));
				randoFiles -= 1;
			}
			
			
			var driveNumber:FlxSprite = new FlxSprite(newDrive.getMidpoint().x - 28, 150).loadGraphic(AssetPaths.driveNumbers__png, true, 56, 45);
			driveNumber.animation.frameIndex = driveCount;
			add(driveNumber);
			
			driveCount += 1;
			
			
		}
		
		virusDrive = FlxG.random.int(0, grpDrives.length - 1);
		
		bombSprite = new FlxSprite(grpDrives.members[virusDrive].getMidpoint().x - 20, 200);
		bombSprite.loadGraphic(AssetPaths.bomb__png, true, 40, 64);
		bombSprite.animation.add("idle", [0, 1], 4);
		bombSprite.animation.play("idle");
		add(bombSprite);
		
		bombCountdown = new FlxText(bombSprite.x, bombSprite.y + bombSprite.height, 0, "", 16);
		bombCountdown.font = "assets/data/CONSOLA.TTF";
		add(bombCountdown);
		
		downloadTimer = timerNeeded;
		
		FlxG.sound.volumeUpKeys = null;
		FlxG.sound.volumeDownKeys = null;
		FlxG.sound.muteKeys = null;
		
		var bordersOverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(AssetPaths.borders__png);
		add(bordersOverlay);
		
		FlxG.sound.playMusic("assets/music/760401_Eyescaffe---8-bit.mp3", 0.35);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.sound.play("assets/sounds/keyClickOn" + FlxG.random.int(1, 4) + ".mp3");
		}
		if (FlxG.keys.justReleased.ANY)
		{
			FlxG.sound.play("assets/sounds/keyClickRelease" + FlxG.random.int(1, 4) + ".mp3");
		}
		
		_txtTimer.text = FlxMath.roundDecimal(downloadTimer, 2) + "s until new downloads";
		bombSprite.x = grpDrives.members[virusDrive].getMidpoint().x - 20;
		bombCountdown.x = bombSprite.x;
		bombCountdown.text = FlxMath.roundDecimal(virusTimer, 2) + "s";
		
		
		downloadTimer -= elapsed;
		virusTimer -= elapsed;
		
		if (downloadTimer <= 0)
		{
			downloadFiles();
			timerNeeded *= 0.9;
			downloadTimer = timerNeeded;
		}
		
		if (virusTimer <= 0)
		{
			grpDrives.members[virusDrive].addFile("", 0, true);
			
			FlxG.sound.play(AssetPaths.dabom__mp3);
			virusDrive = FlxG.random.int(0, grpDrives.length - 1);
			virusTimer = virusTimerNeeded;
		}
		
		if ((FlxG.keys.pressed.L && FlxG.keys.justPressed.CONTROL) || (FlxG.keys.justPressed.L && FlxG.keys.pressed.CONTROL))
		{
			clearTerm();
		}
		
		if (cooldown > 0)
		{
			cooldown -= elapsed;
			if (cooldown < 0)
				terminalAdd("Done");
		}
		
		if (_commandLine.hasFocus && FlxG.keys.justPressed.ENTER)
		{
			listCommands.push(_commandLine.text);
			commandParser(_commandLine.text);
			
			_commandLine.text = "";
			_commandLine.caretIndex = 0;
			commandHistory = -1;
		}
		
		if (FlxG.keys.justPressed.UP)
		{
			if (commandHistory == -1 && listCommands.length >= 0)
			{
				commandHistory = listCommands.length - 1;
				
				_commandLine.text = listCommands[commandHistory];
				_commandLine.caretIndex = _commandLine.text.length;
			}
			else if (commandHistory > 0)
			{
				commandHistory -= 1;
				_commandLine.text = listCommands[commandHistory];
				_commandLine.caretIndex = _commandLine.text.length;
			}
		}
		
		if (FlxG.keys.justPressed.DOWN)
		{
			if (commandHistory < listCommands.length - 1 && commandHistory != -1)
			{
				commandHistory += 1;
				_commandLine.text = listCommands[commandHistory];
				_commandLine.caretIndex = _commandLine.text.length;
			}
		}
		
		_commandLine.hasFocus = true;
		
		var osCounter:Int = 0;
		for (d in grpDrives.members)
		{
			for (f in d.grpFiles)
			{
				if (f.fileType == "os")
				{
					osCounter += 1;
					
				}
			}
		}
		
		switch(osCounter)
		{
			case 0:
				FlxG.switchState(new GameoverState());
			case 1:
				// visuals get messed up
			case 2:
				FlxG.sound.music.volume = 0;
		}
	}
	
	private function commandParser(cmd:String):Void
	{
		cmd = cmd.toLowerCase();
		
		var commands = cmd.split(" ");
		var curCommand = commands[0];
		
		
		
		terminalAdd(cmd, true);
		
		if (cooldown > 0)
		{
			terminalAdd("error, intensive compute process in progress, please wait");
			return;
		}
		
		switch(curCommand)
		{
			case "help":
			if (Std.parseInt(commands[1]) <= 1 || Std.parseInt(commands[1]) == null)
			{
				
				terminalAdd("tutorial				- sends some game info");
				terminalAdd("wipe <input>			- wipes the drive completely clean, making it completely empty");
				terminalAdd("push <in> <out>	- moves every file from the input drive to the output drive");
				terminalAdd("clear					- clears the terminal window");
				terminalAdd("clean					- cleans the viruses out (Doesn't recover the files however, just stops them from spreading");
				terminalAdd("driveinfo				- gives you information for each installed drive");
				terminalAdd("upload <input>			- ejects the input drive and uploads the content to the cloud, and re-inserts a new drive");
				terminalAdd("page 1 of 2, use command 'help 2' to see next page");
			}
			if (Std.parseInt(commands[1]) >= 2)
			{
				terminalAdd("move <filetype> <in> <out>	- moves only the specified filetype from input drive to the output drive");
				terminalAdd("keep <filetype> <in> <out> - moves every file unless it is the specified filetype from input to output");
				terminalAdd("mute					- toggles mute");
				terminalAdd("score					- checks your current score");
				terminalAdd("screenshot				- take a screenshot and saves it");
				terminalAdd("volume <volume>		- changes the volume between any value between 0 and 100");
				terminalAdd("credits 					- shoutouts and also the goobers who made this game"); // dont knwo why but this needs an extra tab
				terminalAdd("page 2 of 2");
			}
			
			case "tutorial":
				terminalAdd("The game is controlled via the ingame command line only, use it to move around the data to keep it safe from the virus! Uploading drives gets you points, but if there's virus bits in there you'll get a massive point deduction!");
				terminalAdd("and make sure you don't lose your OS files!");
			case "credits":
				creds();
			case "creds":
				creds();
			case "thanks":
				if (Std.parseInt(commands[1]) <= 1 || Std.parseInt(commands[1]) == null)
				{
					terminalAdd("Special thanks, in no particular order");
					terminalAdd("Tom Fulp and Newgrounds.com and literally everyone on Newgrounds");
					terminalAdd("PhantomArcade");
					terminalAdd("Digimin");
					terminalAdd("BrandyBuizel");
					terminalAdd("muctucc");
					terminalAdd("page 1 of 2");
				}
				
				if (Std.parseInt(commands[1]) >= 2)
				{
					terminalAdd("Dustin Nelson, for letting me borrow his laptop over the weekend");
					terminalAdd("Tim Hortons, for letting me mooch off their internet for a few hours");
					terminalAdd("The HaxeFlixel Community");
					terminalAdd("the guy who made the game Hacknet (if you like this stinky game check that one out!!)");
					terminalAdd("Ludum Dare (and everyone who participates)");
					terminalAdd("page 2 of 2");
				}
				
				
				
			case "wipe":
				var input:Int = Std.parseInt(commands[1]);
				if (Std.parseInt(commands[1]) == null || !FlxMath.inBounds(input, 0, 2))
				{
					driveError();
					return;
				}
				
				var itemsMoved:Int = 0;
				while (grpDrives.members[input].grpFiles.length > 0)
				{
					grpDrives.members[input].grpFiles.forEachExists(function(s:FileSprite)
					{
						grpDrives.members[input].grpFiles.remove(s, true);
						
						itemsMoved += 1;
						
					});
				}
				terminalAdd("drive " + input + " has been wiped, " + itemsMoved + " files deleted");
				
			case "clear":
				clearTerm();
			case "clr":
				clearTerm();
			case "driveinfo":
				for (i in 0...grpDrives.members.length)
				{
					var driveKind:String = grpDrives.members[i].driveType;
					driveKind.toUpperCase();
					terminalAdd("Drive " + i + ": " + driveKind + " Usage: " + FlxMath.roundDecimal(grpDrives.members[i].curSize, 2) + "GB used of " + FlxMath.roundDecimal(grpDrives.members[i].maxCap, 2) + "GB");
				}
				
			case "mute":
				FlxG.sound.toggleMuted();
				terminalAdd("muted: " + FlxG.sound.muted);
				
			case "move":
				moveFiles("move", commands);
			case "keep":
				moveFiles("keep", commands);
			case "freeze":
				cooldown = 5;
			case "volume":
				var volume:Float = Std.parseFloat(commands[1]);
				if (FlxMath.inBounds(volume, 0, 100))
				{
					// Volume is allowed to be set between 0 and 100 to allow for easier, and finer usage by players
					// and then its converted to the acceptable decimal place for Flixel use
					FlxG.sound.volume = volume * 0.01; 
					terminalAdd("volume set to " + volume);
				}
				else
					terminalAdd("Error setting volume, requires a value between 0 and 100");
			case "push":
				moveFiles("push", commands);
			case "upload":
				var input:Int = Std.parseInt(commands[1]);
				if (Std.parseInt(commands[1]) != null && FlxMath.inBounds(input, 0, 2))
				{
					points += grpDrives.members[input].curSize;
					terminalAdd("Uploading drive " + input + " - " + grpDrives.members[input].curSize + "GB of data, please wait");
					
					new FlxTimer().start(grpDrives.members[input].ejectSpeed, function(t:FlxTimer)
					{
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
						
						cooldown = FlxG.random.float(1, grpDrives.members[input].curSize * 0.0007);
						new FlxTimer().start(cooldown, 
											function(t:FlxTimer)
											{
												terminalAdd("Inserted an empty " + grpDrives.members[input].driveType + " in slot " + input + " with " + grpDrives.members[input].maxCap + "GB of free space");
											});
					});
					
				}
				else
				{
					driveError();
				}
			case "screenshot":
				FlxScreenGrab.grab(null, true, true);
				terminalAdd("screenshot taken");
			case "score":
				terminalAdd("You have " + points + " points (how many GBs you've uploaded)");
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
		newText.y = _commandLine.y - 30 * newText.textField.numLines;
		_grpPrevCommands.forEachAlive(function(t:FlxText)
		{
			t.y -= 20 * newText.textField.numLines; 
			if (t.y <= 404)
			{
				t.kill();
			}
		});
		
		_grpPrevCommands.add(newText);
	}
	
	private function creds():Void
	{
		terminalAdd("Made by ninjamuffin99 and FuShark in 72 hours for Ludum Dare 42, 'Running Out Of Space'");
		terminalAdd("Design by ninjamuffin99 and FuShark");
		terminalAdd("Art: FuShark		Programming: ninjamuffin99");
		terminalAdd("Additional help: BrandyBuizel");
		terminalAdd("Made with the HaxeFlixel framework: haxeflixel.com");
		terminalAdd("Game source code on github: github.com/ninjamuffin99/ld42");
		terminalAdd("Shoutouts to Newgrounds.com and i lov u tomfulp");
		terminalAdd("use the 'thanks' command to see a list of sweet and cool people");
	}
	
	private function driveError():Void
	{
		var drvJunk = grpDrives.length - 1;
		terminalAdd("Error in input, expects drive numbers between 0-" + drvJunk + " in parameters");
	}
	
	private function downloadFiles():Void
	{
		for (i in grpDrives.members)
		{
			var filesAmount = FlxG.random.int(0, 6);
			while (filesAmount > 0)
			{
				i.updateSize();
				if (!i.overmaxCap)
				{
					i.addFile(FlxG.random.getObject(DriveSprite.fileTypes, [1, 1, 0, 1]));
				}
				
				filesAmount -= 1;
			}
		}
	}
	
	private function clearTerm():Void
	{
		_grpPrevCommands.forEach(function(t:FlxText)
			{
				t.kill();
			});
			terminalAdd("terminal cleared", true);
			
	}
	
	/**
	 * NOTE: Note directly related to the "move" command, this is a general function to move around files
	 * 
	 * just so its all in one place and behaves the same (somewhat) rather than having some copy paste stinky stuff
	 * 
	 * @param	moveType			
	 * @param	commands		an array of the commands inputed
	 */
	private function moveFiles(moveType:String, commands:Array<String>):Void
	{
		var commandOffset:Int = 0;
		var possibleFile:Bool = false;
		
		if (moveType == "keep" || moveType == "move")
		{
			for (i in DriveSprite.fileTypes)
			{
				if (i == Std.string(commands[1]))
					possibleFile = true;
			}
			
			commandOffset = 1;
		}
		else
			possibleFile = true;
		
		if (commands[1] == null || !possibleFile)
		{
			terminalAdd("error, please specify a proper filetype (os, mp4, mp3, doc)");
			return;
		}
		
		var input:Int = Std.parseInt(commands[1 + commandOffset]);
		var output:Int = Std.parseInt(commands[2 + commandOffset]);
		
		// in this if, i use the Std.parseInt() function because it can also check if nulls and shit
		// whereas if I use input/outputDrive variables, I cant check for null
		if (Std.parseInt(commands[1 + commandOffset]) != null && Std.parseInt(commands[2 + commandOffset]) != null && FlxMath.inBounds(input, 0, grpDrives.length - 1) && FlxMath.inBounds(output, 0, grpDrives.length - 1))
		{
			var moveSpeed:Float = 0;
			
			moveSpeed = grpDrives.members[input].transferSpeed + grpDrives.members[output].transferSpeed;
			
			var itemsMoved:Int = 0;
			
			var moveableItems:Int = grpDrives.members[input].grpFiles.length;
			
			if (moveType == "keep")
			{
				moveSpeed *= 1.1;
			}
			else if (moveType == "move")
			{
				moveSpeed *= 0.2;
			}
			
			terminalAdd("Please wait...moving files");
			new FlxTimer().start(moveSpeed, function(t:FlxTimer)
			{
				// doin this while loop garbage because for some reason the forEach() function doesn't go through every item???
				while (moveableItems > 0)
				{
					grpDrives.members[input].grpFiles.forEachExists(function(s:FileSprite)
					{
						grpDrives.members[output].updateSize();
						if (!grpDrives.members[output].overmaxCap)
						{
							switch (moveType)
							{
								case "push":
									grpDrives.members[output].grpFiles.add(s);
									grpDrives.members[input].grpFiles.remove(s, true);
									
									itemsMoved += 1;
									
									moveableItems -= 1;
									
								case "keep":
									if (s.fileType != commands[1])
									{		
										grpDrives.members[output].grpFiles.add(s);
										grpDrives.members[input].grpFiles.remove(s, true);
										
										itemsMoved += 1;
										
									}
									
									moveableItems -= 1;
								case "move":
									if (s.fileType == commands[1])
									{
										grpDrives.members[output].grpFiles.add(s);
										grpDrives.members[input].grpFiles.remove(s, true);
										itemsMoved += 1;
									}
									
									moveableItems -= 1;
							}
						}
						else
							moveableItems = 0;
						
					});
					
				}
				terminalAdd(itemsMoved + " items moved from drive " + input + " to drive " + output);
				if (grpDrives.members[output].overmaxCap)
					terminalAdd("WARNING: DRIVE IS AT MAX CAPACITY, PLEASE WIPE OR UPLOAD");
			});
			
		}
		else
		{
			var drvJunk = grpDrives.length - 1;
			terminalAdd("Error in input, expects drive numbers between 0-" + drvJunk + " in parameters");
		}
	}
}
