package idiot.log {

	import flash.system.Worker;

	public class Log {

		public static const LEVEL_INFO:uint = 0x1;
		public static const LEVEL_WARN:uint = 0x2;
		public static const LEVEL_DEBUG:uint = 0x3;

		private static const LEVEL_LABELS:Vector.<String> = Vector.<String>([null, "INFO", "WARN", "DBUG"]);

		public function Log() {
		}

		private var _thread:uint;
		private var _msg:String;
		private var _level:uint;
		private var _timestamp:Date;

		public function setup(msg:String, level:uint = LEVEL_INFO):Log {

			_msg = msg;
			_level = level;
			_timestamp = new Date();

			return this;
		}

		public function toString():String {
			var id:uint;
			return "[" + (10 > _timestamp.hours ? "0" : "") + _timestamp.hours + ":" + (10 > _timestamp.minutes ? "0" : "") + _timestamp.minutes + ":" + (10 > _timestamp.seconds ? "0" : "") + _timestamp.seconds + "." + (10 > _timestamp.milliseconds ? "00" : (100 > _timestamp.milliseconds ? "0" : "")) + _timestamp.milliseconds + "]" + "[#" + ((undefined == (id = Worker.current.getSharedProperty("id"))) ? "-" : id) + "]" + "[" + LEVEL_LABELS[_level] + "] " + _msg;
		}

		internal function get msg():String {

			return _msg;
		}

		internal function get level():uint {

			return _level;
		}
	}
}
