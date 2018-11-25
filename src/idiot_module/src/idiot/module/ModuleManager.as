package idiot.module {

	import flash.utils.getDefinitionByName;

	public final class ModuleManager {
		public function ModuleManager() {
		}

		public function boot(clazz:String):void {
			var clz:Class = getDefinitionByName(clazz) as Class;
			var m:IModule = new clz() as IModule;
			
			m.boot();
		}

		public function halt():void {

		}
	}
}
