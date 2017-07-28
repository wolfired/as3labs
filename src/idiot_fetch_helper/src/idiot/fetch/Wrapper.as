package idiot.fetch {

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	public class Wrapper {
		private static const STATUS_IDLE:uint = 0x1;
		private static const STATUS_BUSY:uint = 0x2;

		public function Wrapper() {
			_request = new URLRequest();

			_task_hub = new TaskHub();
		}

		protected var _request:URLRequest;
		protected var _task:Task;

		private var _task_hub:TaskHub;
		private var _status:uint = STATUS_IDLE;

		/**
		 * @param url
		 * @param loading (url:String, loaded:uint, total:uint) => void
		 * @param loaded (url:String, raw:ByteArray) => void
		 */
		public final function fetch(url:String, loading:Function, loaded:Function):void {
			_task_hub.touch(url, loading, loaded);

			this.load();
		}

		protected final function get loadable():Boolean {
			if(0 == _task_hub.busy_count) {
				return false;
			}

			if(STATUS_BUSY == _status) {
				return false;
			}

			_status = STATUS_BUSY;

			_task = _task_hub.pull();

			_request.url = _task.url;

			return true;
		}

		protected final function unlock():void {
			_task_hub.push(_task);

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
