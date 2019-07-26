package idiot.socket {

	import flash.utils.IDataInput;

	public class SocketDumper {
		public function SocketDumper() {
		}

		protected var _len:uint = uint.MAX_VALUE;

		public function dump(di:IDataInput):void {
			if(uint.MAX_VALUE == _len) {
				if(2 > di.bytesAvailable) {
					return;
				}
				_len = di.readUnsignedShort();
			}

			if(di.bytesAvailable < _len) {
				return;
			}

			trace(di.readUTFBytes(_len));

			_len = uint.MAX_VALUE;
		}
	}
}
