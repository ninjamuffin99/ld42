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
		
		overcapTransShit = new FlxSprite().makeGraphic(Std.int(FlxG.width / 3), 410, FlxColor.BLACK);
		overcapTransShit.alpha = 0.7;
		add(overcapTransShit);
		
		overcapWarning = new FlxSprite(FlxG.width * 0.3 * 0.3, 5).loadGraphic(AssetPaths.fullDrive__png);
		add(overcapWarning);
	}
	
	override public function update(elapsed:Float):Void 
	{
		overcapWarning.visible = overmaxCap;
		overcapTransShit.visible = overcapWarning.visible;
		
		switch (driveType)
		{
			case HDD:
				maxCap = 500;
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
					fileColor = FlxColor.GREEN;
				case "mp4":
					sizeGB = FlxG.random.float(0.1, 5);
					fileColor = FlxColor.RED;
				case "os":
					sizeGB = 3;
					fileColor = FlxColor.ORANGE;
				case "doc":
					sizeGB = FlxG.random.float(0.01, 0.5);
					fileColor = FlxColor.BLUE;
				default:
					sizeGB = 20;
					fileColor = FlxColor.YELLOW;
			}
		}
		
		if (infected)
		{
			var deadFile:VirusSprite = new VirusSprite(0, 0);
			deadFile.infected = infected;
			grpFiles.add(deadFile);
		}
		else
		{
			var newFile:FileSprite = new FileSprite(0, 0);
			newFile.makeGraphic(Math.ceil(FlxG.width / 3), Math.ceil(fileSizeRatio(sizeGB)), fileColor);
			newFile.size = sizeGB;
			newFile.fileType = fileType;
			newFile.infected = infected;
			grpFiles.add(newFile);
		}
	}
	
	public function updateSize():Void
	{
		
		var fileSizeAdd:Float = 0;
		grpFiles.forEach(function(spr:FileSprite)
		{
			var arrayPos = grpFiles.members.indexOf(spr);
			var prevSpr:FlxSprite;
			if (spr.infected)
			{
				spr.size = maxCap * 0.2;
			}
			if (arrayPos > 0)
			{
				prevSpr = grpFiles.members[arrayPos - 1];
				spr.y = prevSpr.y + prevSpr.height + 2;
			}
			else
			{
				spr.y = 5;
			}
			
			if (!spr.infected)
			{
				spr.setGraphicSize(Math.ceil(FlxG.width / 3), Math.ceil(fileSizeRatio(spr.size)));
				spr.updateHitbox();
			}
			else
			{
				
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
			overmaxCap = true
		else
			overmaxCap = false;
	}
	
	public function fileSizeRatio(size:Float):Float
	{
		return FlxMath.remapToRange(size, 0, maxCap, 0, 350);
	}
	
}