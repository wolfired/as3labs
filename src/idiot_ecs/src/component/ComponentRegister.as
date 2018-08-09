package component {

	public class ComponentRegister {
		private static const registry:Vector.<Class> = new Vector.<Class>();

		public static function register(clazz:Class):uint {
			return registry.push(clazz) - 1;
		}

		public static function clazz(idx:uint):Class {
			return registry[idx];
		}
	}
}
