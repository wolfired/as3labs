package idiot.thread {

	import flash.events.Event;
	import flash.system.MessageChannel;
	import idiot.codec.ICodec;

	internal final class Channel {
		public function Channel(channel:MessageChannel) {
			_channel = channel;
		}

		private var _channel:MessageChannel;

		public function get channel():MessageChannel {
			return _channel;
		}

		public function serve():void {
			_channel.addEventListener(Event.ACTIVATE, onActivate);
			_channel.addEventListener(Event.DEACTIVATE, onDeactivate);
			_channel.addEventListener(Event.CHANNEL_STATE, onChannelStage);
			_channel.addEventListener(Event.CHANNEL_MESSAGE, onChannelMessage);
		}

		public function send(o:ICodec):void {
			_channel.send(o);
		}

		public function recv():ICodec {
			return _channel.receive() as ICodec;
		}

		private function onActivate(event:Event):void {
		}

		private function onDeactivate(event:Event):void {
		}

		private function onChannelStage(event:Event):void {
		}

		private function onChannelMessage(event:Event):void {
			trace(this.recv());
		}
	}
}
