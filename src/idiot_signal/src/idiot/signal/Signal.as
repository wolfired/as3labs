package idiot.signal {

	public class Signal {

		public function Signal() {
		}

		protected var _signal_id:uint;
		protected var _args:Object;

		public function reset():void {
			_signal_id = 0;
			_args = null;
		}

		public final function get signal_id():uint {

			return _signal_id;
		}

		public final function get args():Object {

			return _args;
		}
	}
}
