package idiot.fetch {

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;

	public final class URLLoaderWrapper extends Wrapper {

		public function URLLoaderWrapper() {
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(ProgressEvent.PROGRESS, onLoading);
			_loader.addEventListener(Event.COMPLETE, onLoaded);
		}

		private var _loader:URLLoader;

		override protected function load():void {
			if(this.loadable) {
				_loader.load(_request);
			}
		}

		override protected function onLoading(event:ProgressEvent):void {
			_loadings[0](_request.url, event.bytesLoaded, event.bytesTotal);
		}

		override protected function onLoaded(event:Event):void {
			_loadings.shift();

			_loadeds.shift()(_request.url, _loader.data);

			this.unlock();
			this.load();
		}
	}
}
