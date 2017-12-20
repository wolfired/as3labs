package idiot.ui {

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class VisualElement {
		protected static const STATE_UP:uint = 0;
		protected static const STATE_DOWN:uint = 1;
		protected static const STATE_OVER:uint = 0;
		protected static const STATE_OUT:uint = 1;

		public function VisualElement() {
			_skins = new Vector.<BitmapData>();
			_canvas = new Sprite();

			_canvas.addEventListener(Event.ADDED_TO_STAGE, addToStage);
			_canvas.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
			_canvas.addEventListener(Event.RENDER, onRender);

			_canvas.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			_canvas.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			_canvas.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);

			_vstate = STATE_UP;
			_hstate = STATE_OUT;
		}

		public var _skins:Vector.<BitmapData>;

		private var _canvas:Sprite;

		private var _vstate:uint;
		private var _hstate:uint;

		private var _x:int;
		private var _y:int;

		public function get x():int {
			return _x;
		}

		public function set x(value:int):void {
			_x = value;
		}

		public function get y():int {
			return _y;
		}

		public function set y(value:int):void {
			_y = value;
		}

		public final function get canvas():Sprite {
			return _canvas;
		}

		public function updateState():void {
			var skin:BitmapData = _skins[(_vstate << 1) + _hstate];
			_canvas.graphics.clear();
			_canvas.graphics.beginBitmapFill(skin);
			_canvas.graphics.drawRect(0, 0, skin.width * 2, skin.height * 2);
			_canvas.graphics.endFill();
		}

		private function addToStage(event:Event):void {
			this.updateState();
		}

		private function removeFromStage(event:Event):void {

		}

		private function onRender(event:Event):void {
			this.updateState();
		}

		private function mouseUp(event:MouseEvent):void {
			if(STATE_UP == _vstate) {
				return;
			}
			_vstate = STATE_UP;

			_canvas.stage.invalidate();
		}

		private function mouseDown(event:MouseEvent):void {
			if(STATE_DOWN == _vstate) {
				return;
			}
			_vstate = STATE_DOWN;

			_canvas.stage.invalidate();
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

			_canvas.stage.invalidate();
		}

		private function mouseOut(event:MouseEvent):void {
			if(STATE_OUT == _hstate) {
				return;
			}
			_hstate = STATE_OUT;

			_canvas.stage.invalidate();
		}
	}
}
