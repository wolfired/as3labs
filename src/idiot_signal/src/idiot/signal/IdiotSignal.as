package idiot.signal {
	
	public class IdiotSignal {
		
		private var _signal_id:uint;
		public final function get signal_id():uint {
			return _signal_id;
		}
		
		public function IdiotSignal(signal_id:uint) {
			_signal_id = signal_id;
		}
		
	}

}
