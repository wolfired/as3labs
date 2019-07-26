package idiot.terminal {

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public final class Terminal extends Sprite {

		public static const output_line:int = 22;
		public static const line_hei:Number = 24.8;
		public static const wid:Number = 832.0;
		public static const font_size:Number = 16.0;
		public static const BLACK:Array = [new GlowFilter(0x000000, 1.0, 1.2, 1.2, 128, BitmapFilterQuality.HIGH)];

		public function Terminal() {
			this.graphics.beginFill(0x282923);
			this.graphics.drawRect(0.0, 0.0, wid, output_line * line_hei);
			this.graphics.endFill();

			this.graphics.beginFill(0x141411);
			this.graphics.drawRect(0.0, output_line * line_hei, wid, line_hei);
			this.graphics.endFill();

			var tf:TextFormat = new TextFormat("CamingoCode", font_size, 0xFFFFFF, false, false, false, null, null, null, 0, 0, 0, 4);

			_output = new TextField();
			_output.type = TextFieldType.DYNAMIC;
			_output.width = wid;
			_output.height = output_line * line_hei;
			_output.multiline = true;
			_output.wordWrap = true;
			_output.filters = BLACK;
			_output.antiAliasType = AntiAliasType.ADVANCED;
			_output.defaultTextFormat = tf;

			this.addChild(_output);

			_input = new TextInput();
			_input.init(wid, line_hei);
			_input.y = output_line * line_hei;
			_input.addEventListener(TextInput.EVENT_CLEAN, onClean);
			_input.addEventListener(TextInput.EVENT_EXEC, onExec);
			_input.addEventListener(TextInput.EVENT_PREV, onPrev);
			_input.addEventListener(TextInput.EVENT_NEXT, onNext);
			this.addChild(_input);

			_texts = [];
			_histories = [];

			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}

		private var _output:TextField;
		private var _input:TextInput;

		private var _texts:Array;
		private var _histories:Array;
		private var _pointer:uint;

		public function open(stage:Stage):void {
			stage.addChild(this);
		}

		public function close():void {
			this.stage.removeChild(this);
		}

		public function print(texts:Array):void {
			_texts = _texts.concat(texts);
			_output.htmlText = _texts.join("<br />");
			_output.scrollV = (_texts.length - output_line) * line_hei;
		}

		private function onDown(event:MouseEvent):void {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);

			this.addEventListener(MouseEvent.MOUSE_UP, onUp);
			this.addEventListener(Event.DEACTIVATE, onDeactivate);

			this.startDrag();
		}

		private function onUp(event:MouseEvent):void {
			this.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			this.removeEventListener(Event.DEACTIVATE, onDeactivate);

			this.stopDrag();
			this.stage.focus = _input.text;

			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}

		private function onDeactivate(event:Event):void {
			this.onUp(null);
		}

		private function onClean(event:Event):void {
			_texts.length = 0;
			_output.htmlText = "";
			_output.scrollV = 0;
		}

		private function onExec(event:Event):void {
			var cmd:String = _input.text.text;

			this.print([cmd]);

			_histories.push(cmd);

			_pointer = _histories.length * 64;

			_input.text.text = "";
		}

		private function onPrev(event:Event):void {
			_input.text.text = _histories[(--_pointer) % _histories.length];
			_input.text.setSelection(_input.text.text.length, _input.text.text.length);
		}

		private function onNext(event:Event):void {
			_input.text.text = _histories[(++_pointer) % _histories.length];
			_input.text.setSelection(_input.text.text.length, _input.text.text.length);
		}
	}
}
