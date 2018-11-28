package idiot.log {

	public final class Logs {

		private static const _ins:Logs = new Logs();

		public static function get ins():Logs {

			return _ins;
		}

		public function Logs() {

			_logs = new Vector.<Log>;
			_log = new Log();
			_level_show = 0;
			_level_save = 0;
		}

		private var _logs:Vector.<Log>;
		private var _log:Log;

		private var _level_show:uint;
		private var _level_save:uint;

		public function set level(value:uint):void {

			_level_show = value;
		}

		public function set level_save(value:uint):void {

			_level_save = value;
		}

		public function log(m:String, l:uint):void {

			var log:Log;

			if(0 < _level_save && log.level == _level_save) {

				log = new Log();
				_logs.push(log);

			} else {

				log = _log;
			}

			log.setup(m, l);

			if(0 == _level_show || log.level == _level_show) {

				this.printLog(log);
			}
		}

		public function print():void {
		}

		private function printLog(log:Log):void {

			trace(log);
		}
	}
}
