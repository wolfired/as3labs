package idiot.fetch {

	import flash.utils.ByteArray;

	public class FetcherTask {

		public function FetcherTask(raw:ByteArray = null) {
			_loaded = fn_loaded;
			_loading = fn_loading;
			_raw = raw;
		}

		private var _url:String = null;
		private var _loaded:Function = null;
		private var _loading:Function = null;

		private var _raw:ByteArray = null;

		private var _bytes_loaded:uint;
		private var _bytes_total:uint;

		public function get url():String {
			return _url;
		}

		public function set url(value:String):void {
			_url = value;
		}

		public function get loaded():Function {
			return _loaded;
		}

		public function set loaded(value:Function):void {
			_loaded = value || fn_loaded;
		}

		public function get loading():Function {
			return _loading;
		}

		public function set loading(value:Function):void {
			_loading = value || fn_loading;
		}

		public function get raw():ByteArray {
			return _raw;
		}

		public function set raw(value:ByteArray):void {
			_raw = value;
		}

		public function get bytes_loaded():uint {
			return _bytes_loaded;
		}

		public function set bytes_loaded(value:uint):void {
			_bytes_loaded = value;
		}

		public function get bytes_total():uint {
			return _bytes_total;
		}

		public function set bytes_total(value:uint):void {
			_bytes_total = value;
		}

		private function fn_loaded(task:FetcherTask):void {
		}

		private function fn_loading(task:FetcherTask):void {
		}
	}
}
