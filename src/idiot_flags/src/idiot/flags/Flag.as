package idiot.flags {

	public class Flag {
		public function Flag() {
		}

		/** 参数名 */
		internal var name:String;
		/** 说明 */
		internal var help:String;
		/** (flags:Flags) => void */
		internal var fn:Function;
	}
}
