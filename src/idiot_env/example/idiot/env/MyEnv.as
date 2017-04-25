package idiot.env {

	import idiot.env.IdiotEnv;

	public class MyEnv extends IdiotEnv {
		public function MyEnv() {
			super();
		}

		public function get server():String {
			return this.loadString("server", "192.168.1.200");
		}

		public function get port():int {
			return this.loadInt("port", 8080);
		}

		public function get isGM():Boolean {
			return this.loadBoolean("isGM", false);
		}
	}
}
