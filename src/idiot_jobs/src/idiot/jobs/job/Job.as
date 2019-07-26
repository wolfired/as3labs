package idiot.jobs.job {

	public class Job {
		public function Job() {
		}

		private var _exec:Function;
		private var _thiz:Object;

		/**
		 * @param exec (done:Function) => void <br/> done: () => void
		 * @param thiz
		 *
		 * @return
		 */
		public final function setup(exec:Function, thiz:Object = null):Job {
			_exec = exec;
			_thiz = thiz;

			return this;
		}

		/**
		 * @param done () => void
		 *
		 * @return
		 */
		public final function exec(done:Function):Boolean {
			return _exec.call(_thiz, done);
		}
	}
}
