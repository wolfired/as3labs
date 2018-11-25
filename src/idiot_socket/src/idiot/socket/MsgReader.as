package idiot.socket {

	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	public final class MsgReader implements IReader {
		public function MsgReader() {
		}

		private var _len:uint = uint.MAX_VALUE;
		private var _bytes:ByteArray = new ByteArray();

		public function read(di:IDataInput):Boolean {
			if(uint.MAX_VALUE == _len) {
				if(2 > di.bytesAvailable) {
					return false;
				}
				_len = di.readUnsignedShort();
			}

			if(_len > di.bytesAvailable) {
				return false;
			}

			_bytes.length = 0;

			di.readBytes(_bytes, 0, _len);

			_len = uint.MAX_VALUE;

			for(var i:int = 0; i < _bytes.length; ++i) {
				trace(_bytes[i]);
			}

			return true;
		}
	}
}
