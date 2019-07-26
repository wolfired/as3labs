package idiot.module {

	import flash.utils.getDefinitionByName;

	public final class Modules {
		public function Modules() {
		}

		public function boot(clazz:String):void {
			var clz:Class = getDefinitionByName(clazz) as Class;
			var m:Module = new clz() as Module;

			m.boot();
		}

		public function halt():void {

		}
	}
}
