package idiot.jobs {

	public final class JobsQueue extends Jobs {
		private static const _ins:JobsQueue = new JobsQueue();

		public static function get ins():JobsQueue {
			return _ins;
		}

		public function JobsQueue() {
		}

		override protected function get next():Job {
			return _jobs.shift();
		}
	}
}
