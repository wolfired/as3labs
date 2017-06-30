package idiot.fetch {

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	public class Wrapper {
		private static const STATUS_IDLE:uint = 0x1;
		private static const STATUS_BUSY:uint = 0x2;

		public function Wrapper() {
			_request = new URLRequest();

			_urls = new Vector.<String>();
			_loadings = new Vector.<Function>();
			_loadeds = new Vector.<Function>();
		}

		protected var _request:URLRequest;

		protected var _urls:Vector.<String>;
		protected var _loadings:Vector.<Function>
		protected var _loadeds:Vector.<Function>

		private var _status:uint = STATUS_IDLE;

		/**
		 * @param url
		 * @param loading (url:String, loaded:uint, total:uint) => void
		 * @param loaded (url:String, raw:ByteArray) => void
		 */
		public final function fetch(url:String, loading:Function, loaded:Function):void {
			_urls.push(url);
			_loadings.push(loading);
			_loadeds.push(loaded);

			this.load();
		}

		protected final function get loadable():Boolean {
			if(0 == _urls.length) {
				return false;
			}

			if(STATUS_BUSY == _status) {
				return false;
			}
			_status = STATUS_BUSY

			_request.url = _urls.shift();

			return true;
		}

		protected final function unlock():void {
			_status = STATUS_IDLE;
		}

		protected function load():void {
			throw new Error("need override");
		}

		protected function onLoading(event:ProgressEvent):void {
			throw new Error("need override");
		}

		protected function onLoaded(event:Event):void {
			throw new Error("need override");
		}
	}
}
