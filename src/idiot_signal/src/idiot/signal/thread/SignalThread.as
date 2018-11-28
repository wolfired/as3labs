package idiot.signal.thread {

	import idiot.signal.Signal;

	public class SignalThread extends Signal {

		/**
		 * 创建线程 <br/>
		 * args = { bs:ByteArray:线程字节码 }
		 */
		public static const CREATE:uint = THREAD + 1; // 201
		/**
		 * 启动线程 <br/>
		 * args = { tid:uint:线程ID }
		 */
		public static const START:uint = THREAD + 2; // 202
		/**
		 * 停止线程 <br/>
		 * args = { tid:uint:线程ID }
		 */
		public static const TERMINATE:uint = THREAD + 3; // 203

		public function SignalThread() {
			super();
		}

		public function setup(signal_id:uint, args:Object):SignalThread {

			_signal_id = signal_id;
			_args = args;

			return this;
		}
	}
}
