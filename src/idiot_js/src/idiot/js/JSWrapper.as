package idiot.js {

	import flash.external.ExternalInterface;

	public class JSWrapper {
		public static function log(msg:String):void {
			if(!ExternalInterface.available) {
				return;
			}

			ExternalInterface.call("window.console.log", msg);
		}

		public static function confirm(msg:String):void {
			if(!ExternalInterface.available) {
				return;
			}

			ExternalInterface.call("window.confirm", msg);
		}
	}
}
