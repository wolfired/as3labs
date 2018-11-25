package idiot.thread {

	import flash.concurrent.Condition;
	import flash.concurrent.Mutex;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;

	public final class Threads {
		private static var _singleton:Threads;

		/**
		 * 需要先调用Threads.unsupported()以检查是否支持线程
		 * @return
		 */
		public static function get singleton():Threads {
			return _singleton;
		}

		public static function get unsupported():Boolean {
			return !WorkerDomain.isSupported || null == (_singleton || (_singleton = new Threads(new Singleton())));
		}

		public function Threads(singleton:Singleton) {
			_threads = new Vector.<Thread>();
			_threads.push(Thread.current);

			if(Mutex.isSupported) {
				_mutex = new Mutex();
			}

			if(Condition.isSupported) {
				_condition = new Condition(_mutex);
			}
		}

		private var _threads:Vector.<Thread>;
		private var _mutex:Mutex;
		private var _condition:Condition;

		public function create(swf:ByteArray, fire:Boolean = false):Thread {
			const thread:Thread = _threads[_threads.push(new Thread(WorkerDomain.current.createWorker(swf), _threads.length)) - 1];

			if(fire) {
				thread.start();
			}

			return thread;
		}

		public function thread(id:uint):Thread {
			return _threads[id];
		}
	}
}

class Singleton {
}
