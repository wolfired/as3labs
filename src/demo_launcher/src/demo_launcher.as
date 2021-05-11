package {

	import flash.display.Sprite;
	import demo.embed.ins.env_embed;
	import idiot.quick.QuickBack;
	import idiot.quick.QuickLauncher;
	import idiot.quick.QuickProg;

	[SWF(width="950",height="550")]
	public class demo_launcher extends Sprite {

		public function demo_launcher() {
			new QuickLauncher(env_embed, this, QuickBack, QuickProg);
		}
	}
}
