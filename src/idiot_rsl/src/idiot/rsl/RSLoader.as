package idiot.rsl {

	import flash.display.Loader;
	import flash.events.Event;
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
			_loader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(event:UncaughtErrorEvent):void {
				event.preventDefault();
				trace("loader uncaught error events: ", event.error);
			});

			_ctx_map = [];
			_ctx_map[MERGE] = new LoaderContext(false, ApplicationDomain.currentDomain);
			_ctx_map[APPEND] = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));
		}

		private var _loader:Loader;
		private var _ctx_map:Array;

		public function load(bytes:ByteArray, ctx:uint = RSLoader.MERGE):uint {
			var idx:uint;

			if(STANDALONE == ctx) {
				idx = _ctx_map.push(new LoaderContext(false, new ApplicationDomain(null)));
			} else {
				idx = ctx;
			}

			_loader.loadBytes(bytes, _ctx_map[idx]);

			return idx;
		}
	}
}
