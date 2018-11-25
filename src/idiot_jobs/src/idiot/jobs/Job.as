package idiot.jobs {

	import idiot.pool.IPoolable;

	public class Job implements IPoolable {

		public function Job() {
		}

		private var _exec:Function;
		private var _thiz:Object;

		public final function exec(done:Function):Boolean {
			return _exec.call(_thiz, done);
		}

		public function reset():void {
		}

		public function setup(exec:Function, thiz:Object):Job {
			_exec = exec;
			_thiz = thiz;

			return this;
		}
	}
}
