package idiot.quick {

	import idiot.env.Env;

	public class QuickEnv extends Env {
		public function QuickEnv() {
			super();
		}

		private var _preloads:Vector.<String>;

		public function get preloads():Vector.<String> {
			if(null == _preloads) {
				var str:String = this.loadString("preloads", "");
				_preloads = Vector.<String>(str.match(/[_\.a-zA-Z0-9]+/g));
			}

			return _preloads;
		}

		public function get loadingbackground():String {
			return this.loadString("loadingbackground", "./loadingback.jpg");
		}
	}
}
