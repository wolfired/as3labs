package idiot.rsl {

	import flash.display.Loader;
	import flash.events.UncaughtErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public final class RSLoader {
		public static const STANDALONE:uint = 0x0;
		public static const MERGE:uint = 0x1;
		public static const APPEND:uint = 0x2;

		public function RSLoader() {
			_loader = new Loader();
			_loader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(event:UncaughtErrorEvent):void {
				event.preventDefault();
				trace("loader uncaught error events: ", event.error);
			});

			_ctxs = new Vector.<LoaderContext>(3, true);
			_ctxs[STANDALONE] = new LoaderContext(false, new ApplicationDomain(null));
			_ctxs[MERGE] = new LoaderContext(false, ApplicationDomain.currentDomain);
			_ctxs[APPEND] = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));
		}

		private var _loader:Loader;
		private var _ctxs:Vector.<LoaderContext>;

		public function load(bytes:ByteArray, ctx:uint = MERGE):void {
			_loader.loadBytes(bytes, _ctxs[ctx]);
		}
	}
}
