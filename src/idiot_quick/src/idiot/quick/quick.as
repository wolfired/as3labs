package idiot.quick {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;

	public function quick(root:Sprite, envClz:Class, progClz:Class):void {
		_root = root;
		_env = new envClz() as QuickEnv;
		_prog = new progClz() as QuickProg;

		_root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		_root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onRootProgress);
		_root.loaderInfo.addEventListener(Event.COMPLETE, onRootComplete);
	}
}

import flash.display.Loader;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.UncaughtErrorEvent;
import idiot.fetch.Fetcher;
import idiot.fetch.FetcherTask;
import idiot.fetch.StreamFetcher;
import idiot.js.JSWrapper;
import idiot.quick.QuickEnv;
import idiot.quick.QuickProg;
import idiot.rsl.RSLoader;
import idiot.rsl.RSLoaderTask;

var _root:Sprite;
var _env:QuickEnv;
var _prog:QuickProg;

function onUncaughtError(event:UncaughtErrorEvent):void {
	event.preventDefault();

	trace("root uncaught error events: ", event.error);
	JSWrapper.log("root uncaught error events: " + event.error);
}

function onRootProgress(event:ProgressEvent):void {
	trace(event.bytesLoaded, ", ", event.bytesTotal);
	JSWrapper.log(event.bytesLoaded + ", " + event.bytesTotal);
}

function onRootComplete(event:Event):void {
	_root.stage.align = StageAlign.TOP_LEFT;
	_root.stage.quality = StageQuality.BEST;
	_root.stage.scaleMode = StageScaleMode.NO_SCALE;

	_env.setup(_root.stage, boot);
}

function boot():void {
	var hei:uint = 0;
	var wid:uint = 0;

	var bg:Loader = _root.addChild(new Loader()) as Loader;
	
	_prog.setup();
	_root.addChild(_prog);

	function resize(event:Event):void {
		bg.x = (_root.stage.stageWidth - wid) / 2;
		bg.y = (_root.stage.stageHeight - hei) / 2;

		if(0 > bg.x) {
			_prog.x = _root.stage.stageWidth - _prog.width;
		} else {
			_prog.x = bg.x + wid - _prog.width;
		}

		if(0 > bg.y) {
			_prog.y = _root.stage.stageHeight - _prog.height;
		} else {
			_prog.y = bg.y + hei - _prog.height;
		}
	}

	var sf:StreamFetcher = new StreamFetcher();

	sf.fetch(_env.loadingbackground, function(task:FetcherTask):void {

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

				_root.stage.addEventListener(Event.RESIZE, resize);
				break;
			}
		}

	});

	var f:Fetcher = new Fetcher();
	var rsl:RSLoader = new RSLoader();
	var urls:Vector.<String> = _env.preloads.concat();
	var url:String;

	function fetch():void {
		if(0 == urls.length) {
//			root.stage.removeEventListener(Event.RESIZE, resize);
			return;
		}

		url = urls.shift();

		f.fetch(url, function(ft:FetcherTask):void {

			_prog.setProg(ft.bytes_loaded, ft.bytes_total, _env.preloads.length - urls.length, _env.preloads.length);

			rsl.load(ft.raw, function(rt:RSLoaderTask):void {

				fetch();

			});

		}, function(ft:FetcherTask):void {

			_prog.setProg(ft.bytes_loaded, ft.bytes_total, _env.preloads.length - urls.length, _env.preloads.length);

		});
	}

	fetch();
}
