package entity {

	import component.ComponentRegister;
	import component.IComponent;

	public class Entity implements IEntity {
		public function Entity() {
		}

		private const _component_map:Array = [];

		public function attachComponent(register_id:uint):IComponent {
			var comp:IComponent = _component_map[register_id] as IComponent;

			if(null == comp) {
				var clazz:Class = ComponentRegister.clazz(register_id) as Class;
				_component_map[register_id] = comp = new clazz();
				comp.host = this;
			}

			return comp;
		}

		public function detachComponent(register_id:uint):void {
			var comp:IComponent = _component_map[register_id] as IComponent;

			if(null == comp) {
				return;
			}

			delete _component_map[register_id];

			comp.free();
			comp.host = null;
		}
	}
}
