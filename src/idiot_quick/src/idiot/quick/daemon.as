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
import flash.net.registerClassAlias;
import idiot.codec.Ping;
import idiot.js.JSWrapper;
import idiot.thread.Thread;

var _root:Sprite;

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

	registerClassAlias("Ping", Ping);
	Thread.current.send(new Ping());
}
