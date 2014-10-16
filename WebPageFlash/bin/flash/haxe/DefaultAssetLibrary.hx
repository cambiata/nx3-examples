package;


import haxe.Timer;
import haxe.Unserializer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.text.Font;
import openfl.media.Sound;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;
import openfl.Assets;

#if (flash || js)
import openfl.display.Loader;
import openfl.events.Event;
import openfl.net.URLLoader;
#end

#if sys
import sys.FileSystem;
#end

#if ios
import openfl.utils.SystemPath;
#end


@:access(openfl.media.Sound)
class DefaultAssetLibrary extends AssetLibrary {
	
	
	public var className (default, null) = new Map <String, Dynamic> ();
	public var path (default, null) = new Map <String, String> ();
	public var type (default, null) = new Map <String, AssetType> ();
	
	private var lastModified:Float;
	private var timer:Timer;
	
	
	public function new () {
		
		super ();
		
		#if flash
		
		className.set ("wav/0.data", __ASSET__wav_0_data);
		type.set ("wav/0.data", AssetType.BINARY);
		className.set ("wav/1.data", __ASSET__wav_1_data);
		type.set ("wav/1.data", AssetType.BINARY);
		className.set ("wav/2.data", __ASSET__wav_2_data);
		type.set ("wav/2.data", AssetType.BINARY);
		className.set ("wav/3.data", __ASSET__wav_3_data);
		type.set ("wav/3.data", AssetType.BINARY);
		className.set ("wav/4.data", __ASSET__wav_4_data);
		type.set ("wav/4.data", AssetType.BINARY);
		className.set ("wav/79.data", __ASSET__wav_79_data);
		type.set ("wav/79.data", AssetType.BINARY);
		className.set ("wav/80.data", __ASSET__wav_80_data);
		type.set ("wav/80.data", AssetType.BINARY);
		className.set ("wav/81.data", __ASSET__wav_81_data);
		type.set ("wav/81.data", AssetType.BINARY);
		className.set ("wav/82.data", __ASSET__wav_82_data);
		type.set ("wav/82.data", AssetType.BINARY);
		className.set ("wav/83.data", __ASSET__wav_83_data);
		type.set ("wav/83.data", AssetType.BINARY);
		className.set ("wav/84.data", __ASSET__wav_84_data);
		type.set ("wav/84.data", AssetType.BINARY);
		className.set ("wav/dummy.txt", __ASSET__wav_dummy_txt);
		type.set ("wav/dummy.txt", AssetType.TEXT);
		
		
		#elseif html5
		
		var id;
		id = "wav/0.data";
		path.set (id, id);
		type.set (id, AssetType.BINARY);
		id = "wav/1.data";
		path.set (id, id);
		type.set (id, AssetType.BINARY);
		id = "wav/2.data";
		path.set (id, id);
		type.set (id, AssetType.BINARY);
		id = "wav/3.data";
		path.set (id, id);
		type.set (id, AssetType.BINARY);
		id = "wav/4.data";
		path.set (id, id);
		type.set (id, AssetType.BINARY);
		id = "wav/79.data";
		path.set (id, id);
		type.set (id, AssetType.BINARY);
		id = "wav/80.data";
		path.set (id, id);
		type.set (id, AssetType.BINARY);
		id = "wav/81.data";
		path.set (id, id);
		type.set (id, AssetType.BINARY);
		id = "wav/82.data";
		path.set (id, id);
		type.set (id, AssetType.BINARY);
		id = "wav/83.data";
		path.set (id, id);
		type.set (id, AssetType.BINARY);
		id = "wav/84.data";
		path.set (id, id);
		type.set (id, AssetType.BINARY);
		id = "wav/dummy.txt";
		path.set (id, id);
		type.set (id, AssetType.TEXT);
		
		
		#else
		
		#if (windows || mac || linux)
		
		var useManifest = false;
		
		className.set ("wav/0.data", __ASSET__wav_0_data);
		type.set ("wav/0.data", AssetType.BINARY);
		
		className.set ("wav/1.data", __ASSET__wav_1_data);
		type.set ("wav/1.data", AssetType.BINARY);
		
		className.set ("wav/2.data", __ASSET__wav_2_data);
		type.set ("wav/2.data", AssetType.BINARY);
		
		className.set ("wav/3.data", __ASSET__wav_3_data);
		type.set ("wav/3.data", AssetType.BINARY);
		
		className.set ("wav/4.data", __ASSET__wav_4_data);
		type.set ("wav/4.data", AssetType.BINARY);
		
		className.set ("wav/79.data", __ASSET__wav_79_data);
		type.set ("wav/79.data", AssetType.BINARY);
		
		className.set ("wav/80.data", __ASSET__wav_80_data);
		type.set ("wav/80.data", AssetType.BINARY);
		
		className.set ("wav/81.data", __ASSET__wav_81_data);
		type.set ("wav/81.data", AssetType.BINARY);
		
		className.set ("wav/82.data", __ASSET__wav_82_data);
		type.set ("wav/82.data", AssetType.BINARY);
		
		className.set ("wav/83.data", __ASSET__wav_83_data);
		type.set ("wav/83.data", AssetType.BINARY);
		
		className.set ("wav/84.data", __ASSET__wav_84_data);
		type.set ("wav/84.data", AssetType.BINARY);
		
		className.set ("wav/dummy.txt", __ASSET__wav_dummy_txt);
		type.set ("wav/dummy.txt", AssetType.TEXT);
		
		
		if (useManifest) {
			
			loadManifest ();
			
			if (Sys.args ().indexOf ("-livereload") > -1) {
				
				var path = FileSystem.fullPath ("manifest");
				lastModified = FileSystem.stat (path).mtime.getTime ();
				
				timer = new Timer (2000);
				timer.run = function () {
					
					var modified = FileSystem.stat (path).mtime.getTime ();
					
					if (modified > lastModified) {
						
						lastModified = modified;
						loadManifest ();
						
						if (eventCallback != null) {
							
							eventCallback (this, "change");
							
						}
						
					}
					
				}
				
			}
			
		}
		
		#else
		
		loadManifest ();
		
		#end
		#end
		
	}
	
	
	public override function exists (id:String, type:AssetType):Bool {
		
		var assetType = this.type.get (id);
		
		#if pixi
		
		if (assetType == IMAGE) {
			
			return true;
			
		} else {
			
			return false;
			
		}
		
		#end
		
		if (assetType != null) {
			
			if (assetType == type || ((type == SOUND || type == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if ((assetType == BINARY || assetType == TEXT) && type == BINARY) {
				
				return true;
				
			} else if (path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (type == BINARY || type == null) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getBitmapData (id:String):BitmapData {
		
		#if pixi
		
		return BitmapData.fromImage (path.get (id));
		
		#elseif (flash)
		
		return cast (Type.createInstance (className.get (id), []), BitmapData);
		
		#elseif openfl_html5
		
		return BitmapData.fromImage (ApplicationMain.images.get (path.get (id)));
		
		#elseif js
		
		return cast (ApplicationMain.loaders.get (path.get (id)).contentLoaderInfo.content, Bitmap).bitmapData;
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), BitmapData);
		else return BitmapData.load (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):ByteArray {
		
		#if (flash)
		
		return cast (Type.createInstance (className.get (id), []), ByteArray);

		#elseif (js || openfl_html5 || pixi)
		
		var bytes:ByteArray = null;
		var data = ApplicationMain.urlLoaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			bytes = new ByteArray ();
			bytes.writeUTFBytes (data);
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}

		if (bytes != null) {
			
			bytes.position = 0;
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), ByteArray);
		else return ByteArray.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if pixi
		
		return null;
		
		#elseif (flash || js)
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		if (className.exists(id)) {
			var fontClass = className.get(id);
			Font.registerFont(fontClass);
			return cast (Type.createInstance (fontClass, []), Font);
		} else return new Font (path.get (id));
		
		#end
		
	}
	
	
	public override function getMusic (id:String):Sound {
		
		#if pixi
		
		return null;
		
		#elseif (flash)
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif openfl_html5
		
		var sound = new Sound ();
		sound.__buffer = true;
		sound.load (new URLRequest (path.get (id)));
		return sound; 
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		else return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}
	
	
	public override function getPath (id:String):String {
		
		#if ios
		
		return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		#else
		
		return path.get (id);
		
		#end
		
	}
	
	
	public override function getSound (id:String):Sound {
		
		#if pixi
		
		return null;
		
		#elseif (flash)
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		else return new Sound (new URLRequest (path.get (id)), null, type.get (id) == MUSIC);
		
		#end
		
	}
	
	
	public override function getText (id:String):String {
		
		#if js
		
		var bytes:ByteArray = null;
		var data = ApplicationMain.urlLoaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			return cast data;
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}
		
		if (bytes != null) {
			
			bytes.position = 0;
			return bytes.readUTFBytes (bytes.length);
			
		} else {
			
			return null;
		}
		
		#else
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:AssetType):Bool {
		
		#if flash
		
		if (type != AssetType.MUSIC && type != AssetType.SOUND) {
			
			return className.exists (id);
			
		}
		
		#end
		
		return true;
		
	}
	
	
	public override function list (type:AssetType):Array<String> {
		
		var items = [];
		
		for (id in this.type.keys ()) {
			
			if (type == null || exists (id, type)) {
				
				items.push (id);
				
			}
			
		}
		
		return items;
		
	}
	
	
	public override function loadBitmapData (id:String, handler:BitmapData -> Void):Void {
		
		#if pixi
		
		handler (getBitmapData (id));
		
		#elseif (flash || js)
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBitmapData (id));
			
		}
		
		#else
		
		handler (getBitmapData (id));
		
		#end
		
	}
	
	
	public override function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		#if pixi
		
		handler (getBytes (id));
		
		#elseif (flash || js)
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = new ByteArray ();
				bytes.writeUTFBytes (event.currentTarget.data);
				bytes.position = 0;
				
				handler (bytes);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBytes (id));
			
		}
		
		#else
		
		handler (getBytes (id));
		
		#end
		
	}
	
	
	public override function loadFont (id:String, handler:Font -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getFont (id));
			
		//}
		
		#else
		
		handler (getFont (id));
		
		#end
		
	}
	
	
	#if (!flash && !html5)
	private function loadManifest ():Void {
		
		try {
			
			#if blackberry
			var bytes = ByteArray.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = ByteArray.readFile ("../res/manifest");
			#elseif emscripten
			var bytes = ByteArray.readFile ("assets/manifest");
			#else
			var bytes = ByteArray.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				bytes.position = 0;
				
				if (bytes.length > 0) {
					
					var data = bytes.readUTFBytes (bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<Dynamic> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							if (!className.exists (asset.id)) {
								
								path.set (asset.id, asset.path);
								type.set (asset.id, Type.createEnum (AssetType, asset.type));
								
							}
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest (bytes was null)");
				
			}
		
		} catch (e:Dynamic) {
			
			trace ('Warning: Could not load asset manifest (${e})');
			
		}
		
	}
	#end
	
	
	public override function loadMusic (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getMusic (id));
			
		//}
		
		#else
		
		handler (getMusic (id));
		
		#end
		
	}
	
	
	public override function loadSound (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getSound (id));
			
		//}
		
		#else
		
		handler (getSound (id));
		
		#end
		
	}
	
	
	public override function loadText (id:String, handler:String -> Void):Void {
		
		#if js
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (event.currentTarget.data);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getText (id));
			
		}
		
		#else
		
		var callback = function (bytes:ByteArray):Void {
			
			if (bytes == null) {
				
				handler (null);
				
			} else {
				
				handler (bytes.readUTFBytes (bytes.length));
				
			}
			
		}
		
		loadBytes (id, callback);
		
		#end
		
	}
	
	
}


#if pixi
#elseif flash

@:keep class __ASSET__wav_0_data extends openfl.utils.ByteArray { }
@:keep class __ASSET__wav_1_data extends openfl.utils.ByteArray { }
@:keep class __ASSET__wav_2_data extends openfl.utils.ByteArray { }
@:keep class __ASSET__wav_3_data extends openfl.utils.ByteArray { }
@:keep class __ASSET__wav_4_data extends openfl.utils.ByteArray { }
@:keep class __ASSET__wav_79_data extends openfl.utils.ByteArray { }
@:keep class __ASSET__wav_80_data extends openfl.utils.ByteArray { }
@:keep class __ASSET__wav_81_data extends openfl.utils.ByteArray { }
@:keep class __ASSET__wav_82_data extends openfl.utils.ByteArray { }
@:keep class __ASSET__wav_83_data extends openfl.utils.ByteArray { }
@:keep class __ASSET__wav_84_data extends openfl.utils.ByteArray { }
@:keep class __ASSET__wav_dummy_txt extends openfl.utils.ByteArray { }


#elseif html5















#elseif (windows || mac || linux)


@:file("assets/wav/0.data") class __ASSET__wav_0_data extends flash.utils.ByteArray {}
@:file("assets/wav/1.data") class __ASSET__wav_1_data extends flash.utils.ByteArray {}
@:file("assets/wav/2.data") class __ASSET__wav_2_data extends flash.utils.ByteArray {}
@:file("assets/wav/3.data") class __ASSET__wav_3_data extends flash.utils.ByteArray {}
@:file("assets/wav/4.data") class __ASSET__wav_4_data extends flash.utils.ByteArray {}
@:file("assets/wav/79.data") class __ASSET__wav_79_data extends flash.utils.ByteArray {}
@:file("assets/wav/80.data") class __ASSET__wav_80_data extends flash.utils.ByteArray {}
@:file("assets/wav/81.data") class __ASSET__wav_81_data extends flash.utils.ByteArray {}
@:file("assets/wav/82.data") class __ASSET__wav_82_data extends flash.utils.ByteArray {}
@:file("assets/wav/83.data") class __ASSET__wav_83_data extends flash.utils.ByteArray {}
@:file("assets/wav/84.data") class __ASSET__wav_84_data extends flash.utils.ByteArray {}
@:file("assets/wav/dummy.txt") class __ASSET__wav_dummy_txt extends flash.utils.ByteArray {}


#end
