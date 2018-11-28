package idiot.terminal {

	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import idiot.flags.Flags;

	public class TextInput extends Sprite {
		public function TextInput():void {
		}

		private var _input:TextField;
		private var _cursor:Cursor;

		public function init(wid:Number, line_hei:Number):void {

			var tf:TextFormat = new TextFormat("CamingoCode", font_size, 0xFFFFFF, false, false, false, null, null, null, 0, 0, 0, 4);

			_input = new TextField();
			_input.type = TextFieldType.INPUT;
			_input.width = wid;
			_input.height = line_hei;
			_input.multiline = false;
			_input.wordWrap = false;
			_input.filters = BLACK;
			_input.antiAliasType = AntiAliasType.ADVANCED;
			_input.defaultTextFormat = tf;

			_input.addEventListener(FocusEvent.FOCUS_IN, onInputFocusIn);
			_input.addEventListener(FocusEvent.FOCUS_OUT, onInputFocusOut);
			_input.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.addChild(_input);

			_cursor = new Cursor(_input, line_hei);
			this.addChild(_cursor);
		}

		public function get text():TextField {

			return _input;
		}

		private function onInputFocusIn(event:FocusEvent):void {

			_cursor.hide();
		}

		private function onInputFocusOut(event:FocusEvent):void {

			_cursor.move();
			_cursor.show();
		}

		private function onKeyUp(event:KeyboardEvent):void {
			if(Keyboard.ENTER != event.keyCode) {
				return;
			}

			Flags.parse(_input.text);

			_input.text = "";
		}
	}
}

import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;

const font_size:Number = 16.0;
const BLACK:Array = [new GlowFilter(0x000000, 1.0, 1.2, 1.2, 128, BitmapFilterQuality.HIGH)];
