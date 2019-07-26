package idiot.module {

	public class Module {
		public function Module() {
		}

		public final function boot():void {
			this.bootSelf();

			this.bootOther();
		}

		public final function halt():void {
			this.haltOther();

			this.haltSelf();
		}

		protected function bootOther():void {

		}

		protected function bootSelf():void {

		}

		protected function haltOther():void {

		}

		protected function haltSelf():void {

		}
	}
}
