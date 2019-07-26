package idiot.quick {

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import idiot.fetch.FetcherTask;
	import idiot.quick.ins.env_quick;
	import idiot.quick.ins.fetcher_stream;

	public class QuickBack extends Loader {

		public function QuickBack():void {
		}

		private var _prog:QuickProg;

		private var _wid:int;
		private var _hei:int;

		public function setup(prog:QuickProg):QuickBack {
			_prog = prog;

			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			return this;
		}

		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			this.stage.addEventListener(Event.RESIZE, this.resize);

			fetcher_stream.fetch(env_quick.loadingbackground, this.onLoaded, this.onLoading);
		}

		private function onRemovedFromStage(event:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			this.stage.removeEventListener(Event.RESIZE, this.resize);

			fetcher_stream.cancel();

			(this.content as Bitmap).bitmapData.dispose();
			(this.content as Bitmap).bitmapData = null;
		}

		private function resize(event:Event):void {
			this.x = (this.stage.stageWidth - _wid) / 2;
			this.y = (this.stage.stageHeight - _hei) / 2;

			if(0 > this.x) {
				_prog.x = this.stage.stageWidth - _prog.width;
			} else {
				_prog.x = this.x + _wid - _prog.width;
			}

			if(0 > this.y) {
				_prog.y = this.stage.stageHeight - _prog.height;
			} else {
				_prog.y = this.y + _hei - _prog.height;
			}
		}

		private function onLoaded(task:FetcherTask):void {
			this.loadBytes(task.raw);
		}

		private function onLoading(task:FetcherTask):void {
			if(11 > task.raw.bytesAvailable) {
				return;
			}

			this.loadBytes(task.raw);

			while(11 < task.raw.bytesAvailable) {
				if(0xffc0 == task.raw.readUnsignedShort()) {
					task.raw.readUnsignedByte();
					task.raw.readUnsignedByte();
					task.raw.readUnsignedByte();

					_hei = task.raw.readUnsignedShort();
					_wid = task.raw.readUnsignedShort();

					this.resize(null);

					break;
				}
			}
		}
	}
}
