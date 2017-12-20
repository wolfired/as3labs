package idiot.ui {

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class VisualStage extends VisualContainer {
		private static const THRESHOLD:int = 500;

		private static const MOUSE_STAGE_NONE:uint = 0;
		private static const MOUSE_STAGE_DOWN:uint = 1;
		private static const MOUSE_STAGE_UP:uint = 2;
		private static const MOUSE_STAGE_MOVE:uint = 3;
		private static const MOUSE_STAGE_CLICK:uint = 4;
		private static const MOUSE_STAGE_DCLICK:uint = 5;

		public function VisualStage(stage:Stage) {
			_stage = stage;

			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_stage.addEventListener(Event.EXIT_FRAME, onExitFrame);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private var _stage:Stage;

		private var _mouse_stage:uint = MOUSE_STAGE_NONE;

		private var _timeout_id:uint = 0;
		
		private function onEnterFrame(event:Event):void {

		}

		private function onExitFrame(event:Event):void {

		}

		private function onMouseDown(event:MouseEvent):void {
			if(MOUSE_STAGE_NONE != _mouse_stage) {
				return;
			}
			_mouse_stage = MOUSE_STAGE_DOWN;

			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		private function onMouseUp(event:MouseEvent):void {
			if(MOUSE_STAGE_DOWN != _mouse_stage) {
				return;
			}
			_mouse_stage = MOUSE_STAGE_UP;

			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function onMouseMove(event:MouseEvent):void {
			if(MOUSE_STAGE_DOWN != _mouse_stage) {
				return;
			}
			_mouse_stage = MOUSE_STAGE_MOVE;

			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
	}
}
