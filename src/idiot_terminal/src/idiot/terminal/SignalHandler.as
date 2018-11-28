package idiot.terminal {

	import idiot.signal.SignalRouter;
	import idiot.signal.terminal.SignalTerminal;

	internal class SignalHandler {
		private static const _singleton:SignalHandler = new SignalHandler();

		public function SignalHandler() {
			SignalRouter.ins.addHandler(SignalTerminal.PRINT, print);
		}

		private function print(signal:SignalTerminal):void {
			Terminal.print(signal.args.texts as Array);
		}
	}
}
