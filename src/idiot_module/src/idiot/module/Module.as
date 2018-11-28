package idiot.module {

	import flash.utils.getQualifiedClassName;
	import idiot.log.Log;
	import idiot.log.Logs;

	public class Module implements IModule {
		public function Module() {
		}

		public final function boot():void {

			Logs.ins.log(getQualifiedClassName(this) + " booting", Log.LEVEL_INFO);

			this.booting();

			Logs.ins.log(getQualifiedClassName(this) + " booted", Log.LEVEL_INFO);

			this.booted();
		}

		public final function halt():void {

			Logs.ins.log(getQualifiedClassName(this) + " halting", Log.LEVEL_INFO);

			this.halting();

			Logs.ins.log(getQualifiedClassName(this) + " halted", Log.LEVEL_INFO);

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
