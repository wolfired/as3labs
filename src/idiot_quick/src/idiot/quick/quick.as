package idiot.quick {

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;
	import idiot.js.JSWrapper;

	public function quick(root:Sprite, envClz:Class, progClz:Class):void {
		root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(event:UncaughtErrorEvent):void {

			event.preventDefault();

			trace("root uncaught error events: ", event.error);
			JSWrapper.log("root uncaught error events: " + event.error);

		});

		root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, function(event:ProgressEvent):void {

			trace(event.bytesLoaded, ", ", event.bytesTotal);
			JSWrapper.log(event.bytesLoaded + ", " + event.bytesTotal);

		});

		root.loaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {

			root.stage.align = StageAlign.TOP_LEFT;
			root.stage.quality = StageQuality.BEST;
			root.stage.scaleMode = StageScaleMode.NO_SCALE;

			var env:QuickEnv = new envClz() as QuickEnv;
			var prog:QuickProg = new progClz() as QuickProg;

			env.setup(root.stage, function():void {

				boot(root, env, prog);

			});

		});
	}
}

import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import idiot.fetch.Fetcher;
import idiot.fetch.FetcherTask;
import idiot.fetch.StreamFetcher;
import idiot.js.JSWrapper;
import idiot.quick.QuickEnv;
import idiot.quick.QuickProg;
import idiot.rsl.RSLoader;
import idiot.rsl.RSLoaderTask;

function boot(root:Sprite, env:QuickEnv, prog:QuickProg):void {
	var hei:uint = 0;
	var wid:uint = 0;

	var bg:Loader = root.addChild(new Loader()) as Loader;

	prog.setup();
	root.addChild(prog);

	function resize(event:Event):void {
		bg.x = (root.stage.stageWidth - wid) / 2;
		bg.y = (root.stage.stageHeight - hei) / 2;

		if(0 > bg.x) {
			prog.x = root.stage.stageWidth - prog.width;
		} else {
			prog.x = bg.x + wid - prog.width;
		}

		if(0 > bg.y) {
			prog.y = root.stage.stageHeight - prog.height;
		} else {
			prog.y = bg.y + hei - prog.height;
		}
	}

	var sf:StreamFetcher = new StreamFetcher();

	sf.fetch(env.loadingbackground, function(task:FetcherTask):void {

		bg.loadBytes(task.raw);

	}, function(task:FetcherTask):void {

		bg.loadBytes(task.raw);
		while(11 < task.raw.bytesAvailable) {
			if(0xffc0 == task.raw.readUnsignedShort()) {
				task.raw.readUnsignedByte();
				task.raw.readUnsignedByte();
				task.raw.readUnsignedByte();

				hei = task.raw.readUnsignedShort();
				wid = task.raw.readUnsignedShort();

				resize(null);

				root.stage.addEventListener(Event.RESIZE, resize);
				break;
			}
		}

	});

	var f:Fetcher = new Fetcher();
	var rsl:RSLoader = new RSLoader();
	var urls:Vector.<String> = env.preloads.concat();
	var url:String;

	function fetch():void {
		if(0 == urls.length) {
//			root.stage.removeEventListener(Event.RESIZE, resize);
			return;
		}

		url = urls.shift();

		f.fetch(url, function(ft:FetcherTask):void {

			prog.setProg(ft.bytes_loaded, ft.bytes_total, env.preloads.length - urls.length, env.preloads.length);

			rsl.load(ft.raw, function(rt:RSLoaderTask):void {

				fetch();

			});

		}, function(ft:FetcherTask):void {

			prog.setProg(ft.bytes_loaded, ft.bytes_total, env.preloads.length - urls.length, env.preloads.length);

		});
	}

	fetch();
}
