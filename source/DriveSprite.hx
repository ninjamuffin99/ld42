package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;

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
		[],
		[]
	];
	
	public var grpFiles:FlxSpriteGroup;

	public function new(X:Float=0, Y:Float=0, driveType:String = "hdd") 
	{
		super(X, Y);
		
		width = FlxG.width / 3;
		
		grpFiles = new FlxSpriteGroup();
		add(grpFiles);
		
		addFile();
		
		switch (driveType)
		{
			case HDD:
				maxCap = 1000;
			case SSD:
				maxCap = 128;
			case USB:
				maxCap = 32;
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		grpFiles.forEach(function(spr:FlxSprite){});
		
		super.update(elapsed);
	}
	
	public function addFile(sizeGB:Float = 500, fileType:String = ""):Void
	{
		var newFile:FlxSprite = new FlxSprite(0, 0);
		newFile.makeGraphic(Std.int(FlxG.width / 3), Std.int(fileSizeRatio(sizeGB)));
		grpFiles.add(newFile);
		
		filesArray[0].push(sizeGB);
		filesArray[1].push(fileType);
	}
	
	public function fileSizeRatio(size:Float):Float
	{
		return FlxMath.remapToRange(size, 0, maxCap, 0, FlxG.height);
	}
	
}