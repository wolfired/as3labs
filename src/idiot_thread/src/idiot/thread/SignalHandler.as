package idiot.thread {

	import flash.utils.ByteArray;
	import idiot.signal.SignalRouter;
	import idiot.signal.thread.SignalThread;

	internal final class SignalHandler {
		private static const _singleton:SignalHandler = new SignalHandler();

		public function SignalHandler() {
			SignalRouter.ins.addHandler(SignalThread.CREATE, create);
			SignalRouter.ins.addHandler(SignalThread.START, start);
			SignalRouter.ins.addHandler(SignalThread.TERMINATE, terminate);
		}

		private function create(signal:SignalThread):void {
			if(Threads.unsupported) {
				return;
			}

			Threads.singleton.create(signal.args.bs as ByteArray);
		}

		private function start(signal:SignalThread):void {
			Threads.singleton.thread(signal.args.tid as uint).start();
		}

		private function terminate(signal:SignalThread):void {
			Threads.singleton.thread(signal.args.tid as uint).terminate();
		}
	}
}
