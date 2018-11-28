package idiot.signal.terminal {

	import idiot.signal.Signal;

	public class SignalTerminal extends Signal {

		/**
		 * 打印到控制台 <br/>
		 * args = { texts:Array:要打印的文本 }
		 */
		public static const PRINT:uint = TERMINAL + 1; // 301

		public function SignalTerminal() {
			super();
		}

		public function setup(signal_id:uint, args:Object):SignalTerminal {

			_signal_id = signal_id;
			_args = args;

			return this;
		}
	}
}
