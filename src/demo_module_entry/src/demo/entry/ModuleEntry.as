package demo.entry {

	import idiot.module.Module;
	import idiot.module.Modules;

	public class ModuleEntry extends Module {

		public function ModuleEntry() {
		}

		override protected function booted():void {
			Modules.singleton.boot("demo.world::ModuleWorld");
			Modules.singleton.boot("demo.terminal::ModuleTerminal");
		}
	}
}
