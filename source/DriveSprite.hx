package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class DriveSprite extends FlxSpriteGroup 
{
	
	public static inline var HDD:String = "hdd";
	public static inline var SSD:String = "ssd";
	public static inline var USB:String = "usb";
	
	public var curSize:Float = 0;
	public var maxCap:Float = 0;
	
	public var overmaxCap:Bool = false;
	
	public var grpFiles:FlxTypedSpriteGroup<FileSprite>;
	
	public var driveAvailable:Bool = true;
	public var availTimer:Float = 0;
	public var transferSpeed:Float = 0;
	public var ejectSpeed:Float = 0;
	
	public static var fileTypes:Array<String> = 
	[
		"mp3",
		"mp4",
		"os",
		"doc"
	];
	
	public static var driveTypes:Array<String> = 
	[
		"hdd",
		"ssd",
		"usb"
	];
	
	public var numViruses:Int = 0;
	
	public var driveType:String = "";
	
	private var overcapWarning:FlxSprite;
	private var overcapTransShit:FlxSprite;

	public function new(X:Float=0, Y:Float=0, driveType:String = "hdd") 
	{
		super(X, Y);
		
		grpFiles = new FlxTypedSpriteGroup<FileSprite>();
		add(grpFiles);
		
		this.driveType = driveType;
		
		switch (driveType)
		{
			case HDD:
				maxCap = 500;
			case SSD:
				maxCap = 128;
			case USB:
				maxCap = 32;
		}
		
		overcapTransShit = new FlxSprite(5).makeGraphic(Std.int(FlxG.width / 3 - 10), 410, FlxColor.BLACK);
		overcapTransShit.alpha = 0.7;
		add(overcapTransShit);
		
		overcapWarning = new FlxSprite(FlxG.width * 0.3 * 0.3 + 5, 5).loadGraphic(AssetPaths.fullDrive__png);
		add(overcapWarning);
	}
	
	override public function update(elapsed:Float):Void 
	{
		overcapWarning.visible = overmaxCap;
		overcapTransShit.visible = overcapWarning.visible;
		
		switch (driveType)
		{
			case HDD:
				maxCap = 250;
				transferSpeed = 3;
				ejectSpeed = 10;
			case SSD:
				maxCap = 128;
				transferSpeed = 1;
				ejectSpeed = 5;
			case USB:
				maxCap = 32;
				transferSpeed = 4;
				ejectSpeed = 0.2;
		}
		
		updateSize();
		
		super.update(elapsed);
	}
	
	public function addFile(fileType:String = "", sizeGB:Float = 0, infected:Bool = false):Void
	{
		var fileColor:Int = 0;
		if (sizeGB == 0)
		{
			switch(fileType)
			{
				case "mp3":
					sizeGB = 0.1;
					fileColor = 0xFFb0ff9b;
				case "mp4":
					sizeGB = FlxG.random.float(0.1, 5);
					fileColor = 0xFFc59bff;
				case "os":
					sizeGB = 3;
					fileColor = 0xFF636aff;
				case "doc":
					sizeGB = FlxG.random.float(0.01, 0.5);
					fileColor = 0xFF9bf6ff;
				default:
					sizeGB = 20;
					fileColor = FlxColor.YELLOW;
			}
		}
		
		if (infected)
		{
			var deadFile:VirusSprite = new VirusSprite(10, 0);
			deadFile.infected = infected;
			grpFiles.add(deadFile);
			
			numViruses += 1;
		}
		else
		{
			var newFile:FileSprite = new FileSprite(7, 0);
			newFile.makeGraphic(Math.ceil(FlxG.width / 3) - 10, Math.ceil(fileSizeRatio(sizeGB)), fileColor);
			newFile.y = 410 - 2 - newFile.height;
			newFile.size = sizeGB;
			newFile.fileType = fileType;
			newFile.infected = infected;
			grpFiles.add(newFile);
		}
	}
	
	public function updateSize():Void
	{
		numViruses = 0;
		var fileSizeAdd:Float = 0;
		grpFiles.forEach(function(spr:FileSprite)
		{
			var arrayPos = grpFiles.members.indexOf(spr);
			if (grpFiles.members.length > 1)
			{
				var prevSpr:FileSprite = new FileSprite();
				var nextSpr:FileSprite = new FileSprite();
				
				if (arrayPos > 0)
				{
					prevSpr = grpFiles.members[arrayPos - 1];
					spr.y = prevSpr.y - spr.height - 2;
				}
				else
				{
					spr.y = 410 - 4 - spr.height;
					nextSpr = grpFiles.members[arrayPos + 1];
				}
				
				if (arrayPos < grpFiles.members.length - 1)
				{
					nextSpr = grpFiles.members[arrayPos + 1];
				}
				else
				{
					prevSpr = grpFiles.members[arrayPos - 1];
				}
				
				if (prevSpr.infected || nextSpr.infected)
				{
					if (FlxG.random.bool(0.1) && !spr.infected)
					{
						var newVirus:VirusSprite = new VirusSprite(10);
						grpFiles.add(newVirus);
						grpFiles.remove(spr, true);
						
						newVirus.size = virusFileSizeRatio(40);
					}
				}
				
			}
			
			if (!spr.infected)
			{
				spr.setGraphicSize(Math.ceil(FlxG.width / 3) - 14, Math.ceil(fileSizeRatio(spr.size)));
				spr.updateHitbox();
			}
			else
			{
				spr.size = virusFileSizeRatio(40);
				numViruses += 1;
			}
			
			
			if (spr.fileType == "doc" && !overmaxCap)
			{
				if (FlxG.random.bool(2))
				{
					spr.size += FlxG.random.float(0.01, 0.03);
				}
			}
			
			fileSizeAdd += spr.size;
		});
		
		curSize = FlxMath.roundDecimal(fileSizeAdd, 2);
		
		if (curSize >= maxCap)
		{
			overmaxCap = true;
		}
		else
			overmaxCap = false;
	}
	
	public function fileSizeRatio(size:Float):Float
	{
		return FlxMath.remapToRange(size, 0, maxCap, 0, 350);
	}
	
	public function virusFileSizeRatio(height:Float):Float
	{
		return FlxMath.remapToRange(height, 0, 350, 0, maxCap);
	}
	
}