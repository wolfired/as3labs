package idiot.thread {

	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerState;
	import idiot.codec.ICodec;

	public final class Thread {
		public static const current:Thread = new Thread(Worker.current, Worker.current.isPrimordial ? uint.MIN_VALUE : uint.MAX_VALUE);

		public function Thread(worker:Worker, id:uint) {
			_id = id;

			_worker = worker;

			if(this.inChildThread) { // 在子线程中
				_m2c = new Channel(_worker.getSharedProperty("p2c") as MessageChannel);
				_m2c.serve();

				_c2m = new Channel(_worker.getSharedProperty("c2p") as MessageChannel);
			} else if(this.isChildThread) { // 在主线程中 且 是子线程
				_worker.addEventListener(Event.ACTIVATE, onActivate);
				_worker.addEventListener(Event.DEACTIVATE, onDeactivate);
				_worker.addEventListener(Event.WORKER_STATE, onWorkerStage);

				_m2c = new Channel(current.worker.createMessageChannel(_worker));
				_worker.setSharedProperty("p2c", _m2c.channel);

				_c2m = new Channel(_worker.createMessageChannel(current.worker));
				_c2m.serve();
				_worker.setSharedProperty("c2p", _c2m.channel);
			}
		}

		private var _id:uint;
		private var _worker:Worker;

		private var _m2c:Channel;
		private var _c2m:Channel;

		public function get id():uint {
			return _id;
		}

		public function get isMainThread():Boolean {
			return uint.MIN_VALUE == _id;
		}

		public function get isChildThread():Boolean {
			return uint.MIN_VALUE != _id;
		}

		public function get inChildThread():Boolean {
			return uint.MAX_VALUE == _id;
		}

		public function start():void {
			SWITCH::debug {
				if(WorkerState.NEW != _worker.state) {
					throw new Error("had started");
				}
			}

			_worker.start();
		}

		public function terminate():Boolean {
			return _worker.terminate();
		}

		public function send(o:ICodec):void {
			this.inChildThread ? _c2m.send(o) : _m2c.send(o);
		}

		public function recv():ICodec {
			return this.inChildThread ? _m2c.recv() : _c2m.recv();
		}

		public function get state():String {
			return _worker.state;
		}

		internal function get worker():Worker {
			return _worker;
		}

		private function onActivate(event:Event):void {
//			trace("Thread #" + _id + " is Activated");
		}

		private function onDeactivate(event:Event):void {
//			trace("Thread #" + _id + " is Deactivated");
		}

		/**
		 * 目测此方法只在主线程才会被调用
		 * @param event
		 */
		private function onWorkerStage(event:Event):void {
			trace("Thread #" + _id + " is " + _worker.state);
		}
	}
}
