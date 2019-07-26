package idiot.quick {

	import flash.display.Sprite;

	public class QuickProg extends Sprite {
		public function QuickProg() {
		}

		public function setup():QuickProg {
			this.graphics.clear();

			this.graphics.beginFill(0x282923, 0.6);
			this.graphics.drawRect(0.0, 0.0, 132, 38);
			this.graphics.endFill();

			return this;
		}

		public function setProg(sc:uint, sm:uint, c:uint = 0, m:uint = 0):void {
			this.graphics.clear();

			this.graphics.beginFill(0x282923, 0.6);
			this.graphics.drawRect(0.0, 0.0, 132, 38);
			this.graphics.endFill();

			this.graphics.beginFill(0x00C853, 0.6);
			this.graphics.drawRect(2.0, 2.0, (sc / sm) * 128, 16);
			this.graphics.drawRect(2.0, 20.0, (c / m) * 128, 16);
			this.graphics.endFill();
		}
	}
}
