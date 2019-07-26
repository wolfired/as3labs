package idiot.terminal {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;

	[Event(name="text_input_event_clean", type="idiot.terminal.TextInput")]
	[Event(name="text_input_event_exec", type="idiot.terminal.TextInput")]
	[Event(name="text_input_event_next", type="idiot.terminal.TextInput")]
	[Event(name="text_input_event_prev", type="idiot.terminal.TextInput")]
	public class TextInput extends Sprite {

		public static const EVENT_EXEC:String = "text_input_event_exec";
		public static const EVENT_PREV:String = "text_input_event_prev";
		public static const EVENT_NEXT:String = "text_input_event_next";
		public static const EVENT_CLEAN:String = "text_input_event_clean";

		private static const font_size:Number = 16.0;
		private static const BLACK:Array = [new GlowFilter(0x000000, 1.0, 1.2, 1.2, 128, BitmapFilterQuality.HIGH)];

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

			_input.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
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

		private function onTextInput(event:TextEvent):void {
			if(22 > event.text.charCodeAt(0)) {//按着Ctrl+L或Ctrl+U会出现乱码
				event.preventDefault();
			}
		}

		private function onInputFocusIn(event:FocusEvent):void {
			_cursor.hide();
		}

		private function onInputFocusOut(event:FocusEvent):void {
			_cursor.move();
			_cursor.show();
		}

		private function onKeyUp(event:KeyboardEvent):void {
			switch(event.keyCode) {
				case Keyboard.ENTER:  {
					this.dispatchEvent(new Event(EVENT_EXEC));
					break;
				}
				case Keyboard.UP:  {
					this.dispatchEvent(new Event(EVENT_PREV));
					break;
				}
				case Keyboard.DOWN:  {
					this.dispatchEvent(new Event(EVENT_NEXT));
					break;
				}
				case Keyboard.L:  {
					if(event.ctrlKey) {
						this.dispatchEvent(new Event(EVENT_CLEAN));
					}
					break;
				}
				case Keyboard.R:  {
					if(event.ctrlKey) {
						//TODO 搜索历史命令
					}
					break;
				}
				case Keyboard.U:  {
					if(event.ctrlKey) {
						_input.text = "";
					}
					break;
				}
			}
		}
	}
}
