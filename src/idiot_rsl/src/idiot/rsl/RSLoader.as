package idiot.rsl {

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public final class RSLoader {
		public static const MERGE:uint = 0x0;
		public static const APPEND:uint = 0x1;
		public static const STANDALONE:uint = 0x2;

		public function RSLoader() {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoading);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			_loader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(event:UncaughtErrorEvent):void {
				event.preventDefault();
				trace("loader uncaught error events: ", event.error);
			});

			_ctx_map = new Vector.<LoaderContext>();
			_ctx_map[MERGE] = new LoaderContext(false, ApplicationDomain.currentDomain);
			_ctx_map[APPEND] = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));

			_ctx_map[MERGE].allowCodeImport = true;
			_ctx_map[APPEND].allowCodeImport = true;

			_task = new RSLoaderTask();
		}

		private var _loader:Loader;
		private var _ctx_map:Vector.<LoaderContext>;

		private var _task:RSLoaderTask;

		/**
		 * @param bytes
		 * @param loaded (task:Task) => void
		 * @param policy
		 * @return
		 */
		public function load(bytes:ByteArray, loaded:Function, loading:Function = null, policy:uint = RSLoader.MERGE):uint {
			_task.loaded = loaded;
			_task.loading = loading;

			var ctx:LoaderContext;
			var idx:uint;

			if(STANDALONE == policy) {
				idx = _ctx_map.push(ctx = new LoaderContext(false, new ApplicationDomain(null))) - 1;
				ctx.allowCodeImport = true;
			} else {
				idx = policy;
				ctx = _ctx_map[idx];
			}

			_loader.loadBytes(bytes, ctx);

			return idx;
		}

		private function onLoading(event:ProgressEvent):void {
			_task.loading(_task);
		}

		private function onLoaded(event:Event):void {
			_task.loaded(_task);
		}
	}
}
