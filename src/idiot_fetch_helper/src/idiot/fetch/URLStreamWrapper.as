package idiot.fetch {

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	public final class URLStreamWrapper extends Wrapper {

		public function URLStreamWrapper() {
			super();

			_streamer = new URLStream();
			_streamer.addEventListener(ProgressEvent.PROGRESS, onLoading);
			_streamer.addEventListener(Event.COMPLETE, onLoaded);
		}

		private var _streamer:URLStream;

		private var _dat:ByteArray;

		override protected function load():void {
			if(this.loadable) {
				_dat = new ByteArray();
				_streamer.load(_request);
			}
		}

		override protected function onLoading(event:ProgressEvent):void {
			_loadings[0](_request.url, event.bytesLoaded, event.bytesTotal);

			if(this.extract()) {
				_loadeds[0](_request.url, _dat);
			}
		}

		override protected function onLoaded(event:Event):void {
			_loadings.shift();

			if(this.extract()) {
				_loadeds.shift()(_request.url, _dat);
			}

			this.unlock();
			this.load();
		}

		private function extract():Boolean {
			if(0 < _streamer.bytesAvailable) {
				_streamer.readBytes(_dat, _dat.length);
				return true;
			}
			return false;
		}
	}
}
