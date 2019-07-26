package idiot.thread {

	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;

	public final class Thread {
		public static function wrap():Thread {
			if(!WorkerDomain.isSupported) {
				return null;
			}

			var pid:uint = 0;
			var id:uint = 0;
			var worker:Worker = Worker.current;
			var sender:Channel;
			var recver:Channel;

			if(!worker.isPrimordial) {
				pid = worker.getSharedProperty("pid") as uint;
				id = worker.getSharedProperty("id") as uint;

				sender = new Channel("sender", worker.getSharedProperty("sender") as MessageChannel);
				recver = new Channel("recver", worker.getSharedProperty("recver") as MessageChannel);
			}

			return new Thread(pid, id, worker, sender, recver);
		}

		public function Thread(pid:uint, id:uint, worker:Worker, sender:Channel = null, recver:Channel = null) {
			_pid = pid;
			_id = id;
			_cid = 0;

			_sender = sender;
			_recver = recver;

			_worker = worker;
			_worker.addEventListener(Event.ACTIVATE, onActivate);
			_worker.addEventListener(Event.DEACTIVATE, onDeactivate);
			_worker.addEventListener(Event.WORKER_STATE, onWorkerStage);
		}

		private var _pid:uint;
		private var _id:uint;
		private var _cid:uint;
		private var _worker:Worker;

		private var _sender:Channel;
		private var _recver:Channel;

		public function fork(swf:ByteArray):Thread {
			var worker:Worker = WorkerDomain.current.createWorker(swf);

			worker.setSharedProperty("pid", _id);
			worker.setSharedProperty("id", ++_cid);

			var sender:Channel = new Channel("sender", _worker.createMessageChannel(worker));
			worker.setSharedProperty("recver", sender.channel);

			var recver:Channel = new Channel("recver", worker.createMessageChannel(_worker));
			worker.setSharedProperty("sender", recver.channel);

			return new Thread(_id, _cid, worker, sender, recver);
		}

		public function get sender():Channel {
			return _sender;
		}

		public function get recver():Channel {
			return _recver;
		}

		public function start():void {
			_worker.start();
		}

		public function terminate():Boolean {
			return _worker.terminate();
		}

		public function get info():String {
			return "pid=" + _pid + ", id=" + _id;
		}

		private function onActivate(event:Event):void {
			trace("  Thread.onWorkerActivate", this.info);
		}

		private function onDeactivate(event:Event):void {
			trace("Thread.onWorkerDeactivate", this.info);
		}

		private function onWorkerStage(event:Event):void {
			trace("     Thread.onWorkerStage", this.info, ":", _worker.state);
		}
	}
}
