package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
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
	
	
	public var maxCap:Float = 0;
	
	public var filesArray:Array<Dynamic> = 
	[
		[], // size
		[]	// fileType
	];
	
	public var grpFiles:FlxSpriteGroup;
	
	public static var fileTypes:Array<String> = 
	[
		"mp3",
		"mp4",
		"os",
		"doc"
	];
	
	public var driveType:String = "";

	public function new(X:Float=0, Y:Float=0, driveType:String = "hdd") 
	{
		super(X, Y);
		
		grpFiles = new FlxSpriteGroup();
		add(grpFiles);
		
		this.driveType = driveType;
		
		switch (driveType)
		{
			case HDD:
				maxCap = 1000;
			case SSD:
				maxCap = 128;
			case USB:
				maxCap = 32;
		}
		
		addFile(FlxG.random.getObject(fileTypes));
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		grpFiles.forEachAlive(function(spr:FlxSprite)
		{
			var arrayPos = grpFiles.members.indexOf(spr);
			var prevSpr:FlxSprite;
			if (arrayPos > 0)
			{
				prevSpr = grpFiles.members[arrayPos - 1];
				spr.y = prevSpr.y + prevSpr.height;
			}
			else
			{
				spr.y = 0;
			}
			
			spr.setGraphicSize(Math.ceil(FlxG.width / 3), Math.ceil(fileSizeRatio(filesArray[0][arrayPos])));
			spr.updateHitbox();
			
			if (filesArray[1][arrayPos] == "doc")
			{
				if (FlxG.random.bool(2))
				{
					filesArray[0][arrayPos] += FlxG.random.float(0.01, 0.03);
				}
			}
			
		});
		
		super.update(elapsed);
	}
	
	public function addFile(fileType:String = ""):Void
	{
		var sizeGB:Float = 0;
		var fileColor:Int = 0;
		
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
				fileColor = FlxColor.GRAY;
			case "doc":
				sizeGB = FlxG.random.float(0.01, 0.5);
				fileColor = FlxColor.BLUE;
			default:
				sizeGB = 20;
				fileColor = FlxColor.YELLOW;
		}
		
		var newFile:FlxSprite = new FlxSprite(0, 0);
		newFile.makeGraphic(Math.ceil(FlxG.width / 3), Math.ceil(fileSizeRatio(sizeGB)), fileColor);
		grpFiles.add(newFile);
		
		
		filesArray[0].push(sizeGB);
		filesArray[1].push(fileType);
	}
	
	public function fileSizeRatio(size:Float):Float
	{
		return FlxMath.remapToRange(size, 0, maxCap, 0, FlxG.height * 0.7);
	}
	
}