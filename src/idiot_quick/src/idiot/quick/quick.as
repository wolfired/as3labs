package idiot.quick {

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;

	public function quick(root:Sprite, envClz:Class):void {
		root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(event:UncaughtErrorEvent):void {
			event.preventDefault();
			trace("root uncaught error events: ", event.error);
		});

		root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, function(event:ProgressEvent):void {
			trace(event.bytesLoaded, ", ", event.bytesTotal);
		});

		root.loaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
			root.stage.align = StageAlign.TOP_LEFT;
			root.stage.quality = StageQuality.BEST;
			root.stage.scaleMode = StageScaleMode.NO_SCALE;

			var env:QuickEnv = new envClz() as QuickEnv;
			env.setup(root.stage, function():void {
				boot(root, env);
			});
		});
	}
}

import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.ByteArray;
import idiot.fetch.URLLoaderWrapper;
import idiot.fetch.URLStreamWrapper;
import idiot.quick.QuickEnv;
import idiot.rsl.RSLoader;

function boot(root:Sprite, env:QuickEnv):void {
	var bg:Loader = root.addChild(new Loader()) as Loader;

	var hei:uint;
	var wid:uint;

	function resize(event:Event):void {
		bg.x = (root.stage.stageWidth - wid) / 2;
		bg.y = (root.stage.stageHeight - hei) / 2;
	}

	var s:URLStreamWrapper = new URLStreamWrapper();
	s.fetch(env.loadingbackground, function(url:String, loaded:uint, total:uint):void {}, function(url:String, raw:ByteArray):void {
		bg.loadBytes(raw);
		while(11 < raw.bytesAvailable) {
			if(0xffc0 == raw.readUnsignedShort()) {
				raw.readUnsignedByte();
				raw.readUnsignedByte();
				raw.readUnsignedByte();

				hei = raw.readUnsignedShort();
				wid = raw.readUnsignedShort();

				resize(null);

				root.stage.addEventListener(Event.RESIZE, resize);
				break;
			}
		}
	});

	var rsl:RSLoader = new RSLoader();
	var l:URLLoaderWrapper = new URLLoaderWrapper();

	for each(var preload:String in env.preloads) {
		l.fetch(preload, function(url:String, loaded:uint, total:uint):void {}, function(url:String, raw:ByteArray):void {
			rsl.load(raw);
		});
	}

	root.stage.removeEventListener(Event.RESIZE, resize);
}
