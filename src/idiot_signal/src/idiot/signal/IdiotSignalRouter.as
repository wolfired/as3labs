package idiot.signal {

	public class IdiotSignalRouter {

		public function IdiotSignalRouter() {

		}

		private var _id_handlers_map:Array = [];

		public final function addHandler(signal_id:uint, handler:Function):void {
			var index:int = this.indexOfHandler(signal_id, handler);

			if(-1 != index) {
				return;
			}
			this.getHandlers(signal_id).push(handler);
		}

		public final function delHandler(signal_id:uint, handler:Function):void {
			var index:int = this.indexOfHandler(signal_id, handler);

			if(-1 == index) {
				return;
			}
			this.getHandlers(signal_id).splice(index, 1);
		}

		public final function clnHnadler(signal_id:uint):void {
			this.getHandlers(signal_id).length = 0;
		}

		public final function route(signal:IdiotSignal):void {
			var handlers:Vector.<Function> = this.getHandlers(signal.signal_id);

			for each(var handler:Function in handlers) {
				handler(signal);
			}
		}

		private function getHandlers(signal_id:uint):Vector.<Function> {
			var handlers:Vector.<Function> = _id_handlers_map[signal_id] as Vector.<Function>;

			if(null == handlers) {
				_id_handlers_map[signal_id] = handlers = new Vector.<Function>();
			}

			return handlers;
		}

		private function indexOfHandler(signal_id:uint, handler:Function):int {
			return this.getHandlers(signal_id).indexOf(handler);
		}
	}

}
