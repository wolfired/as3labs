package idiot.quick {

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.system.System;
	import flash.utils.getDefinitionByName;
	import idiot.fetch.FetcherTask;
	import idiot.jobs.job.Job;
	import idiot.quick.ins.env_quick;
	import idiot.quick.ins.fetcher;
	import idiot.quick.ins.jobs_queue;
	import idiot.quick.ins.rsl;
	import idiot.rsl.RSLoaderTask;

	public class QuickLauncher {
		public function QuickLauncher(env:QuickEnv, root:Sprite, backClazz:Class, progClazz:Class) {
			env_quick = env;

			_root = root;

			_backClazz = backClazz;
			_progClazz = progClazz;

			_root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
			_root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onRootProgress);
			_root.loaderInfo.addEventListener(Event.COMPLETE, onRootComplete);
		}

		private var _root:Sprite;

		private var _backClazz:Class;
		private var _back:QuickBack;

		private var _progClazz:Class;
		private var _prog:QuickProg;

		protected function onUncaughtError(event:UncaughtErrorEvent):void {
			event.preventDefault();
			trace("loader uncaught error events: ", event.error);
		}

		protected function onRootProgress(event:ProgressEvent):void {
		}

		protected function onRootComplete(event:Event):void {
			_root.stage.align = StageAlign.TOP_LEFT;
			_root.stage.quality = StageQuality.BEST;
			_root.stage.scaleMode = StageScaleMode.NO_SCALE;

			env_quick.setup(_root.stage, this.launch);
		}

		protected function launch():void {
			const urls:Vector.<String> = env_quick.preloads.concat();

			if(0 < urls.length) {
				_prog = _root.addChild((new _progClazz() as QuickProg).setup()) as QuickProg;
				_back = _root.addChildAt((new _backClazz() as QuickBack).setup(_prog), 0) as QuickBack;
			}

			for(var i:int = 0; i < urls.length; ++i) {
				jobs_queue.wait(new Job().setup(function(done:Function):void {
					fetcher.fetch(urls.shift(), function(ft:FetcherTask):void {
						_prog.setProg(ft.bytes_loaded, ft.bytes_total, env_quick.preloads.length - urls.length, env_quick.preloads.length);

						rsl.load(ft.raw, function(rt:RSLoaderTask):void {
							done()
						});
					}, function(ft:FetcherTask):void {
						_prog.setProg(ft.bytes_loaded, ft.bytes_total, env_quick.preloads.length - urls.length, env_quick.preloads.length);
					});
				}));
			}

			jobs_queue.wait(new Job().setup(function(done:Function):void {
				new (getDefinitionByName(env_quick.entry) as Class)({stage: _root.stage});

				done();

				_root.parent.removeChild(_root);

				_root = null;
				_backClazz = null;
				_back = null;
				_progClazz = null;
				_prog = null;

				System.gc();
			}));
		}
	}
}
