package idiot.fetch {

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public final class Fetcher {
		public function Fetcher() {
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(ProgressEvent.PROGRESS, onLoading);
			_loader.addEventListener(Event.COMPLETE, onLoaded);

			_request = new URLRequest();

			_task = new FetcherTask();
		}

		private var _loader:URLLoader;
		private var _request:URLRequest;

		private var _task:FetcherTask;

		/**
		 * @param url
		 * @param loaded (task:FetcherTask) => void
		 * @param loading (task:FetcherTask) => void
		 */
		public function fetch(url:String, loaded:Function, loading:Function = null):void {
			SWITCH::debug {
				if(null != _task.url) {
					throw new Error("URLFetcher: now is loading");
				}
			}

			_task.url = url;
			_task.loaded = loaded;
			_task.loading = loading;

			_task.raw = null;

			_task.bytes_loaded = 0;
			_task.bytes_total = 0;

			_request.url = _task.url;

			_loader.load(_request);
		}

		private function onLoading(event:ProgressEvent):void {
			_task.bytes_loaded = event.bytesLoaded;
			_task.bytes_total = event.bytesTotal;
			_task.loading(_task);
		}

		private function onLoaded(event:Event):void {
			_task.raw = _loader.data as ByteArray;
			_task.loaded(_task);

			SWITCH::debug {
				_task.url = null;
			}
		}
	}
}
