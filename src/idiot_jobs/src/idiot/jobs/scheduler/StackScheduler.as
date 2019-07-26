package idiot.jobs.scheduler {

	/**
	 * 栈调度器
	 * 
	 * @author link
	 */	
	public class StackScheduler extends QueueScheduler {
		public function StackScheduler() {
			super();
		}

		override public function next(done:Function):Function {
			_job = _jobs.pop();

			return wrap(done);
		}
	}
}
