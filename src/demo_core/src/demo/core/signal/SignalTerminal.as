package demo.core.signal {

	public class SignalTerminal extends DemoSignal {
		/**
		 * 打开控制台
		 */
		public static const OPEN:uint = TERMINAL + 1; // 301
		/**
		 * 关闭控制台
		 */
		public static const CLOSE:uint = TERMINAL + 2; // 302
		/**
		 * 打印文本到控制台 <br/>
		 * args = { texts:Array[String]:待打印的文本 }
		 */
		public static const PRINT:uint = TERMINAL + 10; // 310
		/**
		 * 执行控制指令 <br/>
		 * args = { text:String:待执行的命令 }
		 */
		public static const PARSE:uint = TERMINAL + 11; // 311

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
