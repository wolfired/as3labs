package idiot.fetch {

	import idiot.signal.ISignalRouter;
	import idiot.signal.Signal;
	import idiot.signal.SignalRouter;

	public class Fetcher implements ISignalRouter {

		public function Fetcher() {
			_signal_router = new SignalRouter();
		}

		private var _signal_router:SignalRouter;

		public function load(url:String):void {
		}

		public function addHandler(signal_id:uint, handler:Function):void {
			_signal_router.addHandler(signal_id, handler);
		}

		public function delHandler(signal_id:uint, handler:Function):void {
			_signal_router.delHandler(signal_id, handler);
		}

		public function clnHnadler(signal_id:uint):void {
			_signal_router.clnHnadler(signal_id);
		}

		public function route(signal:Signal):void {
			_signal_router.route(signal);
		}
	}
}
