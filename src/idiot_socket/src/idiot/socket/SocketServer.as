package idiot.socket {

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.ObjectEncoding;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class SocketServer {
		public function SocketServer(dumper:SocketDumper) {
			_socket = new Socket();
			_socket.endian = Endian.BIG_ENDIAN;
			_socket.objectEncoding = ObjectEncoding.AMF3;
			_socket.addEventListener(Event.CONNECT, onConnect);
			_socket.addEventListener(Event.CLOSE, onDisconnect);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onMessage);

			_dumper = dumper;
		}

		private var _socket:Socket;
		private var _dumper:SocketDumper;

		public function connect(host:String, port:int, pf_port:int = 0):void {
			if(_socket.connected) {
				return;
			}

			if(0 < pf_port && 843 != pf_port) {
				Security.loadPolicyFile("xmlsocket://" + host + ":" + pf_port);
			}

			_socket.connect(host, port);
		}

		public function disconnect():void {
			if(!_socket.connected) {
				return;
			}

			_socket.close();
		}

		public function send(bytes:ByteArray):void {
			_socket.writeBytes(bytes);
			_socket.flush();
		}

		private function onConnect(event:Event):void {
		}

		private function onDisconnect(event:Event):void {
		}

		private function onMessage(event:ProgressEvent):void {
			_dumper.dump(_socket)
		}
	}
}
