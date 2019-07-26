package idiot.jobs.trigger {

	import flash.display.Shape;
	import flash.events.Event;

	public class FrameTrigger implements Trigger {
		public function FrameTrigger() {
			_shape = new Shape();
		}

		private var _shape:Shape;

		public function fire(next:Function):void {
			_shape.addEventListener(Event.ENTER_FRAME, function(event:Event):void {
				_shape.removeEventListener(Event.ENTER_FRAME, arguments.callee);
				next();
			});
		}
	}
}
