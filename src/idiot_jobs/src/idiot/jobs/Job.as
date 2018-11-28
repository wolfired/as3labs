package idiot.jobs {

	public class Job {

		public function Job() {
		}

		private var _exec:Function;
		private var _thiz:Object;

		public final function exec(done:Function):Boolean {
			return _exec.call(_thiz, done);
		}

		/**
		 * @param exec (done:Function) => Boolean
		 * @param thiz
		 * @return 
		 */
		public function setup(exec:Function, thiz:Object = null):Job {
			_exec = exec;
			_thiz = thiz;

			return this;
		}
	}
}
