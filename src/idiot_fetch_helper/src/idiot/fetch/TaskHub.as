package idiot.fetch {

	internal final class TaskHub {

		private const _idle_pool:Vector.<Task> = new Vector.<Task>();
		private const _busy_pool:Vector.<Task> = new Vector.<Task>();

		public function touch(url:String, loading:Function, loaded:Function):void {
			var task:Task;

			if(0 == _idle_pool.length) {
				task = new Task();
			} else {
				task = _idle_pool.pop();
			}

			task.url = url;
			task.loading = loading;
			task.loaded = loaded;

			_busy_pool.push(task);
		}

		public function pull():Task {
			return _busy_pool.shift();
		}

		public function push(task:Task):void {
			_idle_pool.push(task);
		}

		public function get idle_count():uint {
			return _idle_pool.length;
		}

		public function get busy_count():uint {
			return _busy_pool.length;
		}
	}
}
