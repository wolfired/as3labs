package idiot.jobs.scheduler {

	import idiot.jobs.job.Job;

	/**
	 * 队列调度器
	 *
	 * @author link
	 */
	public class QueueScheduler extends Scheduler {
		public function QueueScheduler() {
			_jobs = new Vector.<Job>();
		}

		protected var _jobs:Vector.<Job>;

		override public function wait(job:Job):void {
			_jobs.push(job);
		}

		override public function next(done:Function):Function {
			_job = _jobs.shift();

			return wrap(done);
		}

		override public function get blocked():Boolean {
			return null != _job || 0 == _jobs.length;
		}
	}
}
