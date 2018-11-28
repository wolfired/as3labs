package idiot.fetch {

	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	public final class BytePipe extends ByteArray {

		private static const _ins:BytePipe = new BytePipe();

		public static function connect(to:IDataInput):BytePipe {

			to.readBytes(_ins, _ins.length);

			return _ins;
		}

		public function BytePipe() {
		}
	}
}
