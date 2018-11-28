package idiot.module {

	public class Module implements IModule {
		public function Module() {
		}

		public final function boot():void {

			this.booting();

			this.booted();
		}

		public final function halt():void {

			this.halting();

			this.halted();
		}

		protected function booting():void {

		}

		protected function booted():void {

		}

		protected function halting():void {

		}

		protected function halted():void {

		}
	}
}
