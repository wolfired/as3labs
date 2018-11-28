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

			const arr:Array = [];

			for(var i:int = 0; i < Math.min(10, _bytes.length); ++i) {
				arr.push(_bytes[i]);
			}

			if(10 < _bytes.length) {
				arr.push("...");
			}

			trace("Socket data: [" + arr.join(", ") + "]");

			return true;
		}
	}
}
