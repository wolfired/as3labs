package component {

	import entity.IEntity;

	public interface IComponent {
		function init(args:Object = null):void;
		function free():void;
		function get host():IEntity;
		function set host(value:IEntity):void;
	}
}
