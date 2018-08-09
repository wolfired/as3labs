package component {

	import entity.IEntity;

	public class Component implements IComponent {
		public function Component() {
		}

		protected var _host:IEntity;

		public function init(args:Object = null):void {

		}

		public function free():void {

		}

		public function get host():IEntity {
			return _host;
		}

		public function set host(value:IEntity):void {
			_host = value;
		}
	}
}
