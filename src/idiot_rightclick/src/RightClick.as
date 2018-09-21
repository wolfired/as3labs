package {

	import flash.display.Stage;
	import flash.events.MouseEvent;

	public class RightClick {
		public function RightClick(stage:Stage) {
			stage.addEventListener(MouseEvent.RIGHT_CLICK, function(event:MouseEvent):void {
				trace(1);
			});
		}
	}
}
