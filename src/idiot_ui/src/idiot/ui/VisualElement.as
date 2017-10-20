package idiot.ui {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class VisualElement {
		public static const STATE_DOWN:uint = 0;
		public static const STATE_UP:uint = 1;
		public static const STATE_OUT:uint = 0;
		public static const STATE_OVER:uint = 1

		public function VisualElement() {
			_skins = new Vector.<BitmapData>();
			_canvas = new Bitmap();
			
			_canvas.addEventListener(Event.ADDED_TO_STAGE, addToStage);
			_canvas.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);

			_canvas.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			_canvas.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			_canvas.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);

			_vstate = STATE_UP;
			_hstate = STATE_OUT;
		}

		public var _skins:Vector.<BitmapData>;

		private var _canvas:Bitmap;

		private var _vstate:uint;
		private var _hstate:uint;

		public function get canvas():Bitmap {
			return _canvas;
		}

		private function addToStage(event:Event):void {

		}

		private function removeFromStage(event:Event):void {

		}

		private function mouseUp(event:MouseEvent):void {
			if(STATE_UP == _vstate) {
				return;
			}
			_vstate = STATE_UP;
			
			this.updateState();
		}

		private function mouseDown(event:MouseEvent):void {
			if(STATE_DOWN == _vstate) {
				return;
			}
			_vstate = STATE_DOWN;
			
			this.updateState();
		}

		private function mouseMove(event:MouseEvent):void {
			if(STATE_OUT == _hstate) {
				return;
			}
		}

		private function mouseOver(event:MouseEvent):void {
			if(STATE_OVER == _hstate) {
				return;
			}
			_hstate = STATE_OVER;
			
			this.updateState();
		}

		private function mouseOut(event:MouseEvent):void {
			if(STATE_OUT == _hstate) {
				return;
			}
			_hstate = STATE_OUT;
			
			this.updateState();
		}

		public function updateState():void {
			_canvas.bitmapData = _skins[_hstate << 1 | _vstate];
		}
	}
}
