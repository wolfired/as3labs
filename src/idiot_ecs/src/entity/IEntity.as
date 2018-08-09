package entity {
	import component.IComponent;

	public interface IEntity {
		function attachComponent(register_id:uint):IComponent;
		function detachComponent(register_id:uint):void;
	}
}
