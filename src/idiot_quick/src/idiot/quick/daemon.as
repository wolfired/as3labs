package idiot.quick {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;

	public function daemon(root:Sprite):void {
		_root = root;

		_root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		_root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onRootProgress);
		_root.loaderInfo.addEventListener(Event.COMPLETE, onRootComplete);
	}
}

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.UncaughtErrorEvent;
import idiot.log.Log;
import idiot.log.Logs;

var _root:Sprite;

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
}
