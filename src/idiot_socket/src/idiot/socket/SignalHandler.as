package idiot.socket {

	import idiot.signal.SignalRouter;
	import idiot.signal.socket.SignalSocket;

	internal final class SignalHandler {
		private static const _singleton:SignalHandler = new SignalHandler();

		public function SignalHandler() {
			SignalRouter.ins.addHandler(SignalSocket.CONNECT, connect);
			SignalRouter.ins.addHandler(SignalSocket.DISCONNECT, disconnect);
		}

		private function connect(signal:SignalSocket):void {
			Server.ins.connect(signal.args.host as String, signal.args.port as int);
		}

		private function disconnect(signal:SignalSocket):void {
			Server.ins.close();
		}
	}
}
