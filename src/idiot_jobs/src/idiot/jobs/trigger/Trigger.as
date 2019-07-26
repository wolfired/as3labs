package idiot.jobs.trigger {

	public interface Trigger {
		/**
		 * @param next () => void
		 */
		function fire(next:Function):void;
	}
}
