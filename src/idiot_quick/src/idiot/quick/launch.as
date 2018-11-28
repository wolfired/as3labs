package idiot.quick {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;

	public function launch(root:Sprite, envClz:Class, progClz:Class):void {
		_root = root;
		_env = new envClz() as QuickEnv;
		_prog = new progClz() as QuickProg;

		_root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		_root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onRootProgress);
		_root.loaderInfo.addEventListener(Event.COMPLETE, onRootComplete);
	}
}

import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.UncaughtErrorEvent;
import flash.system.Security;
import flash.system.System;

import idiot.fetch.Fetcher;
import idiot.fetch.FetcherTask;
import idiot.fetch.StreamFetcher;
import idiot.jobs.JobsQueue;
import idiot.log.Log;
import idiot.log.Logs;
import idiot.module.Modules;
import idiot.quick.QuickEnv;
import idiot.quick.QuickProg;
import idiot.rsl.RSLoader;
import idiot.rsl.RSLoaderTask;
import idiot.stager.Stager;

var _root:Sprite;
var _bg:BG;
var _env:QuickEnv;
var _prog:QuickProg;

function onUncaughtError(event:UncaughtErrorEvent):void {

	event.preventDefault();

	Logs.ins.log("root uncaught error events: " + event.error, Log.LEVEL_INFO);
}

function onRootProgress(event:ProgressEvent):void {

	Logs.ins.log(event.bytesLoaded + ", " + event.bytesTotal, Log.LEVEL_INFO);
}

function onRootComplete(event:Event):void {

	_root.stage.align = StageAlign.TOP_LEFT;
	_root.stage.quality = StageQuality.BEST;
	_root.stage.scaleMode = StageScaleMode.NO_SCALE;

	_env.setup(_root.stage, boot);
}

function boot():void {

	if(843 != _env.pfr) {
		Security.loadPolicyFile("xmlsocket://" + _env.host + ":" + _env.pfr);
	}

	var urls:Vector.<String> = _env.preloads.concat();

	if(0 < urls.length) {

		_bg = new BG();
		_root.addChild(_bg);

		_prog.setup();
		_root.addChild(_prog);
	}

	for(var i:int = 0; i < urls.length; ++i) {

		JobsQueue.ins.wait(function(done:Function):Boolean {

			Fetcher.ins.fetch(urls.shift(), function(ft:FetcherTask):void {

				_prog.setProg(ft.bytes_loaded, ft.bytes_total, _env.preloads.length - urls.length, _env.preloads.length);

				RSLoader.ins.load(ft.raw, function(rt:RSLoaderTask):void {

					done();
				});

			}, function(ft:FetcherTask):void {

				_prog.setProg(ft.bytes_loaded, ft.bytes_total, _env.preloads.length - urls.length, _env.preloads.length);
			});

			return false;
		});
	}

	JobsQueue.ins.wait(function(done:Function):Boolean {

		Stager.singleton.stage = _root.stage;

		_root.parent.removeChild(_root);

		System.gc();

		Modules.singleton.boot(_env.entry);

		return true;
	});
}

class BG extends Loader {

	public function BG():void {

		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private var _wid:int;
	private var _hei:int;

	private function onAddedToStage(event:Event):void {

		this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		StreamFetcher.ins.fetch(_env.loadingbackground, this.onLoaded, this.onLoading);
	}

	private function onRemovedFromStage(event:Event):void {

		this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		this.stage.removeEventListener(Event.RESIZE, this.resize);

		StreamFetcher.ins.cancel();

		(this.content as Bitmap).bitmapData.dispose();
		(this.content as Bitmap).bitmapData = null;
	}

	private function resize(event:Event):void {

		this.x = (this.stage.stageWidth - _wid) / 2;
		this.y = (this.stage.stageHeight - _hei) / 2;

		if(0 > this.x) {

			_prog.x = this.stage.stageWidth - _prog.width;

		} else {

			_prog.x = this.x + _wid - _prog.width;
		}

		if(0 > this.y) {

			_prog.y = this.stage.stageHeight - _prog.height;

		} else {

			_prog.y = this.y + _hei - _prog.height;
		}
	}

	private function onLoaded(task:FetcherTask):void {

		this.loadBytes(task.raw);
	}

	private function onLoading(task:FetcherTask):void {
		if(11 > task.raw.bytesAvailable) {

			return;
		}

		this.loadBytes(task.raw);

		while(11 < task.raw.bytesAvailable) {

			if(0xffc0 == task.raw.readUnsignedShort()) {

				task.raw.readUnsignedByte();
				task.raw.readUnsignedByte();
				task.raw.readUnsignedByte();

				_hei = task.raw.readUnsignedShort();
				_wid = task.raw.readUnsignedShort();

				this.resize(null);

				_root.stage.addEventListener(Event.RESIZE, this.resize);

				break;
			}
		}
	}
}
