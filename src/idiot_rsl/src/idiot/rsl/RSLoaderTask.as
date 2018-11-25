package idiot.rsl {

	import idiot.pool.IPoolable;

	public class RSLoaderTask implements IPoolable {
		public function RSLoaderTask() {
			this.reset();
		}

		private var _loaded:Function = null;
		private var _loading:Function = null;

		public function reset():void {
			_loaded = fn_loaded;
			_loading = fn_loading;
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

		private function fn_loaded(task:RSLoaderTask):void {
		}

		private function fn_loading(task:RSLoaderTask):void {
		}
	}
}
