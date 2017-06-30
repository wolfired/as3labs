package idiot.env {

	import idiot.env.Env;

	public class MyEnv extends Env {
		public function MyEnv() {
			super();
		}

		private var _preloads:Vector.<String>;

		public function get server():String {
			return this.loadString("server", "192.168.1.200");
		}

		public function get port():int {
			return this.loadInt("port", 8080);
		}

		public function get isGM():Boolean {
			return this.loadBoolean("isGM", false);
		}

		public function get preloads():Vector.<String> {
			if(null == _preloads) {
				var str:String = this.loadString("preloads", "commond,main");
				_preloads = Vector.<String>(str.split(","));
			}

			return _preloads;
		}
	}
}
