package idiot.terminal {

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public final class Terminal extends Sprite {

		private static var _terminal:Terminal = new Terminal();

		public static function open(stage:Stage):void {

			stage.addChild(_terminal);
		}

		public static function close():void {

			_terminal.stage.removeChild(_terminal);
		}

		public static function print(texts:Array):void {
			_terminal._texts = _terminal._texts.concat(texts);
			_terminal._output.htmlText = _terminal._texts.join("<br />");
			_terminal._output.scrollV = (_terminal._texts.length - output_line) * line_hei;
		}

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
			this.addChild(_input);

			_texts = [];

			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}

		private var _output:TextField;
		private var _input:TextInput;

		private var _texts:Array;

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
	}
}

import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;

const output_line:int = 22;
const line_hei:Number = 24.8;
const wid:Number = 832.0;
const font_size:Number = 16.0;
const BLACK:Array = [new GlowFilter(0x000000, 1.0, 1.2, 1.2, 128, BitmapFilterQuality.HIGH)];
