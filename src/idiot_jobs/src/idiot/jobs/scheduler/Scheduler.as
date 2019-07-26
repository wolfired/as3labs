package idiot.jobs.scheduler {

	import idiot.jobs.job.Job;

	/**
	 * 调度器, 不要直接使用本类
	 *
	 * @see idiot.jobs.scheduler.QueueScheduler
	 * @see idiot.jobs.scheduler.StackScheduler
	 *
	 * @author link
	 */
	public class Scheduler {
		protected var _job:Job = null;

		public function wait(job:Job):void {
		}

		/**
		 * @param done () => void
		 *
		 * @return
		 */
		public function next(done:Function):Function {
			return this.wrap(done);
		}

		/**
		 * 调度器是否阻塞
		 * @return
		 */
		public function get blocked():Boolean {
			return true;
		}

		/**
		 * @param done () => void
		 *
		 * @return
		 */
		protected final function wrap(done:Function):Function {
			return function():void {
				_job.exec(function():void {
					_job = null;
					done();
				});
			};
		}
	}
}
