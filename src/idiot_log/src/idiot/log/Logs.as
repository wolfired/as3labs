package idiot.log {

	public class Logs {
		private static const _ins:Logs = new Logs();

		public static function get ins():Logs {
			return _ins;
		}

		public function Logs() {
		}

		public function log(s:String):void {
		}
	}
}
