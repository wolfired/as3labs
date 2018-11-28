package idiot.thread {

	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerState;
	
	import idiot.codec.ICodec;

	public final class Thread {
		public static const current:Thread = new Thread(Worker.current, Threads.inMainThread ? uint.MIN_VALUE : uint.MAX_VALUE);

		public function Thread(worker:Worker, id:uint) {
			_id = id;

			_worker = worker;

			if(Threads.inChildThread) { // 在子线程中
				_id = _worker.getSharedProperty("id");

				_m2c = new Channel(_worker.getSharedProperty("p2c") as MessageChannel);
				_m2c.serve();

				_c2m = new Channel(_worker.getSharedProperty("c2p") as MessageChannel);
			} else if(this.isChildThread) { // 在主线程中 且 是子线程
				_worker.setSharedProperty("id", _id);

				_worker.addEventListener(Event.ACTIVATE, onActivate);
				_worker.addEventListener(Event.DEACTIVATE, onDeactivate);
				_worker.addEventListener(Event.WORKER_STATE, onWorkerStage);

				_m2c = new Channel(current.worker.createMessageChannel(_worker));
				_worker.setSharedProperty("p2c", _m2c.channel);

				_c2m = new Channel(_worker.createMessageChannel(current.worker));
				_c2m.serve();
				_worker.setSharedProperty("c2p", _c2m.channel);
			}

			this.started = null;
		}

		private var _id:uint;
		private var _worker:Worker;

		private var _m2c:Channel;
		private var _c2m:Channel;

		private var _started:Function;

		public function get id():uint {
			return _id;
		}

		public function get isMainThread():Boolean {
			return _worker.isPrimordial;
		}

		public function get isChildThread():Boolean {
			return !_worker.isPrimordial;
		}

		/**
		 * @param started () => void
		 */
		public function start(started:Function = null):void {
			SWITCH::debug {
				if(WorkerState.NEW != _worker.state) {
					throw new Error("had started");
				}
			}

			this.started = started;

			_worker.start();
		}

		public function terminate():Boolean {
			return _worker.terminate();
		}

		public function send(o:ICodec):void {
			Threads.inMainThread ? _m2c.send(o) : _c2m.send(o);
		}

		public function recv():ICodec {
			return Threads.inChildThread ? _m2c.recv() : _c2m.recv();
		}

		public function get state():String {
			return _worker.state;
		}

		internal function get worker():Worker {
			return _worker;
		}

		private function get started():Function {
			return _started;
		}

		private function set started(value:Function):void {
			_started = null == value ? fn_started : value;
		}

		private function onActivate(event:Event):void {
		}

		private function onDeactivate(event:Event):void {
		}

		/**
		 * 目测此方法只在主线程才会被调用
		 * @param event
		 */
		private function onWorkerStage(event:Event):void {

			WorkerState.RUNNING == _worker.state && this.started();
		}

		private function fn_started():void {

		}

		private function fn_terminated():void {

		}
	}
}
