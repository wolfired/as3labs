package idiot.jobs {

	import idiot.jobs.scheduler.Scheduler;
	import idiot.jobs.trigger.Trigger;
	import idiot.jobs.job.Job;

	/**
	 * @author LinkWu
	 */
	public final class Jobs {
		public function Jobs(trigger:Trigger, scheduler:Scheduler) {
			_trigger = trigger;
			_scheduler = scheduler;
		}

		private var _trigger:Trigger;
		private var _scheduler:Scheduler;

		/**
		 * @param exec
		 */
		public function wait(job:Job):void {
			_scheduler.wait(job);

			this.fire();
		}

		private function fire():void {
			if(_scheduler.blocked) {
				return;
			}

			_trigger.fire(_scheduler.next(this.fire));
		}
	}
}
