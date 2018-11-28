package demo.terminal {

	import idiot.flags.Flags;
	import idiot.signal.SignalRouter;
	import idiot.signal.terminal.SignalTerminal;
	import idiot.terminal.Terminal;

	internal class SignalHandler {
		private static const _singleton:SignalHandler = new SignalHandler();

		public function SignalHandler() {
			SignalRouter.ins.addHandler(SignalTerminal.PRINT, print);
			SignalRouter.ins.addHandler(SignalTerminal.PARSE, parse);
		}

		private function print(signal:SignalTerminal):void {
			Terminal.print(signal.args.texts as Array);
		}

		private function parse(signal:SignalTerminal):void {
			Flags.parse(signal.args.text as String);
		}
	}
}
