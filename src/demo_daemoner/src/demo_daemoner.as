package {

	import flash.display.Sprite;
	
	import idiot.quick.daemon;

	public class demo_daemoner extends Sprite {

		public function demo_daemoner() {
			daemon(this);
			
			trace("Sub0");
			
			thread.sender.channel.send("Hi, I am Sub0!");
			trace(thread.recver.channel.receive(true));
		}
	}
}
