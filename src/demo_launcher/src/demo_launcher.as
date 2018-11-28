package {

	import flash.display.Sprite;
	import flash.text.Font;
	import idiot.quick.QuickEnv;
	import idiot.quick.QuickProg;
	import idiot.quick.launch;

	public class demo_launcher extends Sprite {

		public function demo_launcher() {
			launch(this, QuickEnv, QuickProg);
		}
	}
}
