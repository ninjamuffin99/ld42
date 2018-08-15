#if !macro


@:access(lime.app.Application)
@:access(lime.Assets)
@:access(openfl.display.Stage)


class ApplicationMain {
	
	
	public static var config:lime.app.Config;
	public static var preloader:openfl.display.Preloader;
	
	
	public static function create ():Void {
		
		var app = new openfl.display.Application ();
		app.create (config);
		
		var display = new flixel.system.FlxPreloader ();
		
		preloader = new openfl.display.Preloader (display);
		app.setPreloader (preloader);
		preloader.onComplete.add (init);
		preloader.create (config);
		
		#if (js && html5)
		var urls = [];
		var types = [];
		
		
		urls.push ("Consolas");
		types.push (lime.Assets.AssetType.FONT);
		
		
		urls.push ("Consolas Bold");
		types.push (lime.Assets.AssetType.FONT);
		
		
		urls.push ("Consolas Italic");
		types.push (lime.Assets.AssetType.FONT);
		
		
		urls.push ("Consolas Bold Italic");
		types.push (lime.Assets.AssetType.FONT);
		
		
		urls.push ("assets/data/data-goes-here.txt");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/images/bomb.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/borders.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/deadDrives.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/driveNumbers.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/fullDrive.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/fullVirusReference.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/images-go-here.txt");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_Background.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_BombContact.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_Bomb_1.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_Bomb_2.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_Bomb_3.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_Bomb_4.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_Bomb_5.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_CorruptedFiles.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DEDDRIVE_HD1.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DEDDRIVE_HD2.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DEDDRIVE_HD3.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DriveBayCross_ON_HD1.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DriveBayCross_ON_HD2.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DriveBayCross_ON_HD3.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DRIVEFULL_BG_HD1.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DRIVEFULL_BG_HD2.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DRIVEFULL_BG_HD3.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DRIVEFULL_TEXT_HD1.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DRIVEFULL_TEXT_HD2.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_DRIVEFULL_TEXT_HD3.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_GRIDTEXTURE_Overlay.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/DED-DRIVE_PAUSE_Overlay.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/EXAMPLE1.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/EXAMPLE10.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/EXAMPLE2.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/EXAMPLE3.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/EXAMPLE4.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/EXAMPLE5.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/EXAMPLE6.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/EXAMPLE7.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/EXAMPLE8.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/EXAMPLE9.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/RENDERS/READMECUTIE-VISUALS.txt");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/images/virus.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/music/760401_Eyescaffe---8-bit.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/music/music-goes-here.txt");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/sounds/dabom.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/keyClickOn1.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/keyClickOn2.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/keyClickOn3.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/keyClickOn4.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/keyClickRelease1.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/keyClickRelease2.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/keyClickRelease3.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/keyClickRelease4.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/sounds-go-here.txt");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("flixel/sounds/beep.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("flixel/sounds/flixel.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("Nokia Cellphone FC Small");
		types.push (lime.Assets.AssetType.FONT);
		
		
		urls.push ("Monsterrat");
		types.push (lime.Assets.AssetType.FONT);
		
		
		urls.push ("flixel/images/ui/button.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/images/logo/default.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/box.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/button.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/button_arrow_down.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/button_arrow_left.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/button_arrow_right.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/button_arrow_up.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/button_thin.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/button_toggle.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/check_box.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/check_mark.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/chrome.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/chrome_flat.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/chrome_inset.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/chrome_light.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/dropdown_mark.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/finger_big.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/finger_small.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/hilight.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/invis.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/minus_mark.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/plus_mark.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/radio.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/radio_dot.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/swatch.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/tab.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/tab_back.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/img/tooltip_arrow.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("flixel/flixel-ui/xml/defaults.xml");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("flixel/flixel-ui/xml/default_loading_screen.xml");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("flixel/flixel-ui/xml/default_popup.xml");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		
		if (config.assetsPrefix != null) {
			
			for (i in 0...urls.length) {
				
				if (types[i] != lime.Assets.AssetType.FONT) {
					
					urls[i] = config.assetsPrefix + urls[i];
					
				}
				
			}
			
		}
		
		preloader.load (urls, types);
		#end
		
		var result = app.exec ();
		
		#if (sys && !nodejs && !emscripten)
		Sys.exit (result);
		#end
		
	}
	
	
	public static function init ():Void {
		
		var loaded = 0;
		var total = 0;
		var library_onLoad = function (__) {
			
			loaded++;
			
			if (loaded == total) {
				
				start ();
				
			}
			
		}
		
		preloader = null;
		
		
		
		
		if (total == 0) {
			
			start ();
			
		}
		
	}
	
	
	public static function main () {
		
		config = {
			
			build: "342",
			company: "HaxeFlixel",
			file: "ld42",
			fps: 60,
			name: "ld42",
			orientation: "",
			packageName: "com.example.myapp",
			version: "0.0.1",
			windows: [
				
				{
					antialiasing: 0,
					background: 0,
					borderless: false,
					depthBuffer: false,
					display: 0,
					fullscreen: false,
					hardware: true,
					height: 640,
					parameters: "{}",
					resizable: true,
					stencilBuffer: true,
					title: "ld42",
					vsync: false,
					width: 960,
					x: null,
					y: null
				},
			]
			
		};
		
		#if hxtelemetry
		var telemetry = new hxtelemetry.HxTelemetry.Config ();
		telemetry.allocations = true;
		telemetry.host = "localhost";
		telemetry.app_name = config.name;
		Reflect.setField (config, "telemetry", telemetry);
		#end
		
		#if (js && html5)
		#if (munit || utest)
		openfl.Lib.embed (null, 960, 640, "000000");
		#end
		#else
		create ();
		#end
		
	}
	
	
	public static function start ():Void {
		
		var hasMain = false;
		var entryPoint = Type.resolveClass ("Main");
		
		for (methodName in Type.getClassFields (entryPoint)) {
			
			if (methodName == "main") {
				
				hasMain = true;
				break;
				
			}
			
		}
		
		lime.Assets.initialize ();
		
		if (hasMain) {
			
			Reflect.callMethod (entryPoint, Reflect.field (entryPoint, "main"), []);
			
		} else {
			
			var instance:DocumentClass = Type.createInstance (DocumentClass, []);
			
			/*if (Std.is (instance, openfl.display.DisplayObject)) {
				
				openfl.Lib.current.addChild (cast instance);
				
			}*/
			
		}
		
		#if !flash
		if (openfl.Lib.current.stage.window.fullscreen) {
			
			openfl.Lib.current.stage.dispatchEvent (new openfl.events.FullScreenEvent (openfl.events.FullScreenEvent.FULL_SCREEN, false, false, true, true));
			
		}
		
		openfl.Lib.current.stage.dispatchEvent (new openfl.events.Event (openfl.events.Event.RESIZE, false, false));
		#end
		
	}
	
	
	#if neko
	@:noCompletion @:dox(hide) public static function __init__ () {
		
		var loader = new neko.vm.Loader (untyped $loader);
		loader.addPath (haxe.io.Path.directory (Sys.executablePath ()));
		loader.addPath ("./");
		loader.addPath ("@executable_path/");
		
	}
	#end
	
	
}


@:build(DocumentClass.build())
@:keep class DocumentClass extends Main {}


#else


import haxe.macro.Context;
import haxe.macro.Expr;


class DocumentClass {
	
	
	macro public static function build ():Array<Field> {
		
		var classType = Context.getLocalClass ().get ();
		var searchTypes = classType;
		
		while (searchTypes.superClass != null) {
			
			if (searchTypes.pack.length == 2 && searchTypes.pack[1] == "display" && searchTypes.name == "DisplayObject") {
				
				var fields = Context.getBuildFields ();
				
				var method = macro {
					
					openfl.Lib.current.addChild (this);
					super ();
					dispatchEvent (new openfl.events.Event (openfl.events.Event.ADDED_TO_STAGE, false, false));
					
				}
				
				fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: [], expr: method, params: [], ret: macro :Void }), pos: Context.currentPos () });
				
				return fields;
				
			}
			
			searchTypes = searchTypes.superClass.t.get ();
			
		}
		
		return null;
		
	}
	
	
}


#end
