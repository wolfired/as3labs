package idiot.jobs {

	public final class JobsStack extends Jobs {
		private static const _ins:JobsStack = new JobsStack();

		public static function get ins():JobsStack {
			return _ins;
		}

		public function JobsStack() {
		}

		override protected function get next():Job {
			return _jobs.pop();
		}
	}
}
