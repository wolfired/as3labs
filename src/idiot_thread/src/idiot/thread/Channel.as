package idiot.thread {

	import flash.events.Event;
	import flash.system.MessageChannel;
	import idiot.codec.ICodec;
	import idiot.log.Log;
	import idiot.log.Logs;

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
//			_channel.addEventListener(Event.CHANNEL_STATE, onChannelStage);
			_channel.addEventListener(Event.CHANNEL_MESSAGE, onChannelMessage);
		}

		public function send(o:ICodec):void {
			_channel.send(o);
		}

		public function recv():ICodec {
			return _channel.receive() as ICodec;
		}

		private function onActivate(event:Event):void {
			Logs.ins.log("channel is Activated", Log.LEVEL_INFO);
		}

		private function onDeactivate(event:Event):void {
			Logs.ins.log("channel is Deactivated", Log.LEVEL_INFO);
		}

		private function onChannelStage(event:Event):void {
			trace("channel is " + _channel.state);
		}

		private function onChannelMessage(event:Event):void {
			trace(Thread.current.id, this.recv());
		}
	}
}
