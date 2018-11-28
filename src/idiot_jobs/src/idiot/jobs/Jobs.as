package idiot.jobs {

	import flash.display.Shape;
	import flash.events.Event;

	/**
	 * 按帧处理已注册工作
	 * @author LinkWu
	 */
	public class Jobs {
		public function Jobs() {
			_trigger = new Shape();
			_jobs = new Vector.<Job>();
		}

		protected var _jobs:Vector.<Job>;

		private var _trigger:Shape;
		private var _job:Job;

		/**
		 * @param exec
		 */
		public final function wait(job:Job):void {
			_jobs.push(job);

			this.fire();
		}

		protected function get next():Job {
			throw new Error("error: have to override");
		}

		private function fire():void {
			if(null != _job || 0 == _jobs.length) {
				return;
			}

			if(!_trigger.hasEventListener(Event.ENTER_FRAME)) {
				_trigger.addEventListener(Event.ENTER_FRAME, this.onFire);
			}
		}

		private function onFire(event:Event):void {
			_trigger.removeEventListener(Event.ENTER_FRAME, this.onFire);

			if((_job = this.next).exec(this.done)) {
				this.done();
			}
		}

		private function done():void {
			_job = null;

			this.fire();
		}
	}
}
