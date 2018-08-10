package idiot.terminal {

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class Terminal extends Sprite {

		private static var _terminal:Terminal = null;

		public static function open(stage:Stage):void {
			if(null == _terminal) {
				_terminal = new Terminal(Singleton.ins);
			}

			stage.addChild(_terminal);
		}

		public static function close():void {
			_terminal.stage.removeChild(_terminal);
		}

		public function Terminal(singleton:Singleton) {
			this.graphics.beginFill(0x282923);
			this.graphics.drawRect(0.0, 0.0, wid, output_line * line_hei);
			this.graphics.endFill();

			this.graphics.beginFill(0x141411);
			this.graphics.drawRect(0.0, output_line * line_hei, wid, line_hei);
			this.graphics.endFill();

			var tf:TextFormat;

			_output.type = TextFieldType.DYNAMIC;
			_output.width = wid;
			_output.height = output_line * line_hei;
			_output.multiline = true;
			_output.wordWrap = true;
			_output.filters = BLACK;

			tf = new TextFormat(null, font_size, 0xFFFFFF, false, false, false, null, null, null, 0, 0, 0, 4);
			_output.defaultTextFormat = tf;

			this.addChild(_output);

			_input.init(wid, line_hei);
			_input.y = output_line * line_hei;
			this.addChild(_input);

			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}

		private const _output:TextField = new TextField();
		private const _input:TextInput = new TextInput();

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

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.utils.getTimer;

const output_line:int = 32;
const line_hei:Number = 20.0;
const wid:Number = 800.0;
const font_size:Number = 16.0;
const BLACK:Array = [new GlowFilter(0x000000, 1.0, 1.2, 1.2, 128, BitmapFilterQuality.HIGH)];

class Singleton {
	public static const ins:Singleton = new Singleton();
}

class TextInput extends Sprite {
	public function TextInput():void {
	}

	private const _input:TextField = new TextField();
	private const _cursor:Cursor = new Cursor(_input);

	public function init(wid:Number, line_hei:Number):void {
		_input.type = TextFieldType.INPUT;
		_input.width = wid;
		_input.height = line_hei;
		_input.multiline = false;
		_input.wordWrap = false;
		_input.filters = BLACK;

		var tf:TextFormat = new TextFormat(null, font_size, 0xFFFFFF, false, false, false, null, null, null, 0, 0, 0, 4);
		_input.defaultTextFormat = tf;

		_input.addEventListener(FocusEvent.FOCUS_IN, onInputFocusIn);
		_input.addEventListener(FocusEvent.FOCUS_OUT, onInputFocusOut);
		this.addChild(_input);

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
}

class Cursor extends Shape {
	public function Cursor(input:TextField):void {
		this.graphics.lineStyle(1.0, 0xFFFFFF);
		this.graphics.moveTo(2, 2);
		this.graphics.lineTo(2, 18);

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
