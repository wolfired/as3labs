package idiot.signal.socket {

	import idiot.signal.Signal;

	public class SignalSocket extends Signal {

		/**
		 * 连接网络 <br/>
		 * args = { host:String:主机, port:int:端口 }
		 */
		public static const CONNECT:uint = SOCKET + 1; // 101
		/**
		 * 断开网络 <br/>
		 * args = null
		 */
		public static const DISCONNECT:uint = SOCKET + 2; // 102

		public function SignalSocket() {
			super();
		}

		public function setup(signal_id:uint, args:Object):SignalSocket {

			_signal_id = signal_id;
			_args = args;

			return this;
		}
	}
}
