package idiot.signal {

	import idiot.pool.IPoolable;

	public class Signal implements IPoolable {

		/** 网络命令 */
		public static const SOCKET:uint = 100;
		/** 线程 */
		public static const THREAD:uint = 200;
		/** 控制台 */
		public static const TERMINAL:uint = 300;

		public function Signal() {
		}

		protected var _args:Object;

		protected var _signal_id:uint;

		public function reset():void {
			_signal_id = 0;
			_args = null;
		}

		public final function get signal_id():uint {

			return _signal_id;
		}

		public final function get args():Object {

			return _args;
		}
	}
}
