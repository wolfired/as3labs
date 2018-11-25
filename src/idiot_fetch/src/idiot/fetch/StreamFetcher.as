package idiot.fetch {

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	public final class StreamFetcher {
		private static const _ins:StreamFetcher = new StreamFetcher();

		public static function get ins():StreamFetcher {
			return _ins;
		}

		public function StreamFetcher() {
			_streamer = new URLStream();
			_streamer.addEventListener(ProgressEvent.PROGRESS, onLoading);
			_streamer.addEventListener(Event.COMPLETE, onLoaded);

			_request = new URLRequest();

			_task = new FetcherTask(new ByteArray());
		}

		private var _streamer:URLStream;
		private var _request:URLRequest;

		private var _task:FetcherTask;

		/**
		 * @param url
		 * @param loaded (task:Task) => void
		 * @param loading (task:Task) => void
		 */
		public function fetch(url:String, loaded:Function, loading:Function = null):void {
			SWITCH::debug {
				if(null != _task.url) {
					throw new Error("URLStreamer: now is loading");
				}
			}

			_task.url = url;
			_task.loaded = loaded;
			_task.loading = loading;

			_task.raw.length = 0;

			_task.bytes_loaded = 0;
			_task.bytes_total = 0;

			_request.url = _task.url;

			_streamer.load(_request);
		}

		private function onLoading(event:ProgressEvent):void {
			this.extract(4096);

			_task.bytes_loaded = event.bytesLoaded;
			_task.bytes_total = event.bytesTotal;
			_task.loading(_task);
		}

		private function onLoaded(event:Event):void {
			this.extract(0);

			_task.loaded(_task);

			SWITCH::debug {
				_task.url = null;
			}
		}

		private function extract(cond:uint):void {
			if(cond > _streamer.bytesAvailable) {
				return;
			}
			_streamer.readBytes(_task.raw, _task.raw.length, cond);
		}
	}
}
