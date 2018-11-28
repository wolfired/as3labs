package idiot.stager {

	import flash.display.Stage;

	public class Stager {

		private static const _singleton:Stager = new Stager();

		public static function get singleton():Stager {
			return _singleton;
		}

		public function Stager() {
		}

		private var _stage:Stage;

		public function get stage():Stage {
			return _stage;
		}

		public function set stage(value:Stage):void {
			_stage = value;
		}
	}
}
