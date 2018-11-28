package idiot.socket {

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.ObjectEncoding;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import idiot.log.Log;
	import idiot.log.Logs;

	public class Server {
		private static const _ins:Server = new Server();

		public static function get ins():Server {
			return _ins;
		}

		public function Server(reader:IReader = null) {
			_sock = new Socket();
			_sock.addEventListener(Event.CONNECT, onConnect);
			_sock.addEventListener(Event.CLOSE, onClose);
			_sock.addEventListener(ProgressEvent.SOCKET_DATA, onMessage);
			_sock.endian = Endian.BIG_ENDIAN;
			_sock.objectEncoding = ObjectEncoding.AMF3;

			_reader = reader || new MsgReader();
		}

		private var _sock:Socket;

		private var _reader:IReader;

		public function connect(host:String, port:int):void {
			if(_sock.connected) {
				return;
			}

			_sock.connect(host, port);
		}

		public function close():void {
			if(!_sock.connected) {
				return;
			}

			_sock.close();
		}

		public function send(bytes:ByteArray, fire:Boolean = false):void {
			_sock.writeBytes(bytes);

			_sock.flush();
		}

		private function onConnect(event:Event):void {
			Logs.ins.log("Socket connected", Log.LEVEL_INFO);
		}

		private function onClose(event:Event):void {
			Logs.ins.log("Socket closed", Log.LEVEL_INFO);
		}

		private function onMessage(event:ProgressEvent):void {
			Logs.ins.log("Socket messaged", Log.LEVEL_INFO);

			if(!_reader.read(_sock)) {
				return;
			}
		}
	}
}
