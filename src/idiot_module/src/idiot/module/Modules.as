package idiot.module {

	import flash.utils.getDefinitionByName;

	public final class Modules {

		private static const _singleton:Modules = new Modules();

		public static function get singleton():Modules {

			return _singleton;
		}

		public function Modules() {
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
