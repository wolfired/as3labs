package {

	import flash.display.Sprite;
	import flash.geom.Point;

	public class idiot_hexagonal {

		public function idiot_hexagonal(canvas:Sprite) {
			_canvas = canvas;

			this.draw_hex(pointy_hex_corner);
		}

		private var _canvas:Sprite;

		private function draw_hex(x_hex_corner:Function):void {
			var center:Point = new Point(100, 100);
			var size:uint = 64;

			_canvas.graphics.lineStyle(1);

			var pos:Point = new Point();

			x_hex_corner(center, size, 0, pos);
			_canvas.graphics.moveTo(pos.x, pos.y);

			for(var i:int = 1; i < 6; ++i) {
				x_hex_corner(center, size, i, pos);
				_canvas.graphics.lineTo(pos.x, pos.y);
			}

			x_hex_corner(center, size, 0, pos);
			_canvas.graphics.lineTo(pos.x, pos.y);
		}
	}
}

import flash.geom.Point;

const DEG2RAD:Number = Math.PI / 180.0;

function flat_hex_corner(center:Point, size:uint, i:int, pos:Point):void {
	var angle_deg:int = 60 * i;
	var angle_rad:Number = DEG2RAD * angle_deg;
	pos.x = center.x + size * Math.cos(angle_rad);
	pos.y = center.y + size * Math.sin(angle_rad);
}

function pointy_hex_corner(center:Point, size:uint, i:int, pos:Point):void {
	var angle_deg:int = 60 * i - 30;
	var angle_rad:Number = DEG2RAD * angle_deg;
	pos.x = center.x + size * Math.cos(angle_rad);
	pos.y = center.y + size * Math.sin(angle_rad);
}
