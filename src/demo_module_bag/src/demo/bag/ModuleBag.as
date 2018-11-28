package demo.bag {

	import idiot.module.Module;

	public class ModuleBag extends Module {
		public function ModuleBag() {
			super();
		}

		override protected function booting():void {
			super.booting();
		}

		override protected function booted():void {
			super.booted();
		}

		override protected function halting():void {
			super.halting();
		}

		override protected function halted():void {
			super.halted();
		}
	}
}
