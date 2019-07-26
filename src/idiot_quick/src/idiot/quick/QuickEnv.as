package idiot.quick {

	import idiot.env.Env;

	public class QuickEnv extends Env {
		public function QuickEnv() {
			super();
		}

		private var _preloads:Vector.<String>;

		/**
		 * 服务器IP
		 */
		public function get host():String {
			return this.loadString("host", "127.0.0.1");
		}

		/**
		 * 服务器端口
		 */
		public function get port():int {
			return this.loadInt("port", 8888);
		}

		/**
		 * 安全沙箱策略文件查询端口
		 */
		public function get pf_port():int {
			return this.loadInt("pf_port", 8889);
		}

		public function get daemon():String {
			return this.loadString("daemon", "./demo_daemoner.swf");
		}

		/**
		 * 入口模块
		 */
		public function get entry():String {
			return this.loadString("entry", "demo.entry::ModuleEntry");
		}

		public function get preloads():Vector.<String> {
			if(null == _preloads) {
				var str:String = this.loadString("preloads", "");
				_preloads = Vector.<String>(str.match(/[_\.a-zA-Z0-9]+/g));
			}

			return _preloads;
		}

		public function get loadingbackground():String {
			return this.loadString("loadingbackground", this.cdn + "/loadingbg.jpg");
		}

		public function get cdn():String {
			return this.loadString("cdn", "http://127.0.0.1:55555");
		}
	}
}
