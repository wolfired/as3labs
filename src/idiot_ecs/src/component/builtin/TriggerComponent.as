package component.builtin {

	import component.Component;
	import component.ComponentRegister;
	import flash.display.Shape;
	import flash.events.Event;

	public class TriggerComponent extends Component {
		public static const IDX:uint = ComponentRegister.register(TriggerComponent);

		public function TriggerComponent() {
			super();
		}

		private const trigger:Shape = new Shape();

		private function onEnterFrame(event:Event):void {
		}
	}
}
