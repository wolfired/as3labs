package demo.entry {

	import flash.display.Stage;
	import idiot.module.Module;
	import idiot.stager.Stager;

	public class ModuleEntry extends Module {

		/**
		 * @param args {stage:Stage}
		 */
		public function ModuleEntry(args:Object) {
			Stager.singleton.stage = args.stage as Stage;

			this.boot();
		}

		override protected function booted():void {
		}
	}
}
