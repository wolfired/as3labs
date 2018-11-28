package idiot.terminal {

	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;

	public class Cursor extends Shape {
		public function Cursor(input:TextField, line_hei:Number):void {
			this.graphics.lineStyle(1.0, 0xFFFFFF);
			this.graphics.moveTo(2.0, 2.0);
			this.graphics.lineTo(2.0, Math.ceil(line_hei) - 2.0);

			_input = input;

			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}

		private var _input:TextField;
		private var _pre_time:int;
		private var _mark:uint;

		public function show():void {

			if(!this.hasEventListener(Event.ENTER_FRAME)) {

				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		public function hide():void {

			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.visible = false;
		}

		public function move():void {

			this.x = _input.textWidth;
		}

		private function onAddToStage(event:Event):void {

			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);

			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			this.stage.focus = _input;
		}

		private function onRemoveFromStage(event:Event):void {

			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event:Event):void {

			var cur_time:int = getTimer();

			if(360 > cur_time - _pre_time) {
				return;
			}

			_pre_time = cur_time;

			if(0 == ++_mark % 2) {
				this.visible = false;
			} else {
				this.visible = true;
			}
		}
	}
}
