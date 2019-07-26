package idiot.thread {

	import flash.events.Event;
	import flash.system.MessageChannel;

	internal final class Channel {
		public function Channel(name:String, channel:MessageChannel) {
			_name = name;

			_channel = channel;
			_channel.addEventListener(Event.ACTIVATE, onActivate);
			_channel.addEventListener(Event.DEACTIVATE, onDeactivate);
			_channel.addEventListener(Event.CHANNEL_STATE, onChannelStage);
			_channel.addEventListener(Event.CHANNEL_MESSAGE, onChannelMessage);
		}

		private var _name:String;
		private var _channel:MessageChannel;

		public function get name():String {
			return _name;
		}

		public function get channel():MessageChannel {
			return _channel;
		}

		public function get info():String {
			return "name=" + _name;
		}

		private function onActivate(event:Event):void {
			trace("       Channel.onActivate", this.info);
		}

		private function onDeactivate(event:Event):void {
			trace("     Channel.onDeactivate", this.info);
		}

		private function onChannelStage(event:Event):void {
			trace("   Channel.onChannelStage", this.info, ":", _channel.state);
		}

		private function onChannelMessage(event:Event):void {
			trace(" Channel.onChannelMessage", this.info);
		}
	}
}
