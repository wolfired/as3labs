package idiot.molehill.model {

	import flash.utils.ByteArray;

	public class Obj {

		public static function parse(raw:ByteArray):Obj {
			var str_obj:String = raw.readUTFBytes(raw.length);

			var arr_v:Array = str_obj.match(/^v(\s[\+\-0-9\.]+)+$/gm);
			var arr_vt:Array = str_obj.match(/^vt(\s[\+\-0-9\.]+)+$/gm);
			var arr_vn:Array = str_obj.match(/^vn(\s[\+\-0-9\.]+)+$/gm);
			var arr_f:Array = str_obj.match(/^f(\s[\d\/]+)+/gm);

			var obj:Obj = new Obj();

			return obj;
		}

		private var _v:Vector.<Number> = new Vector.<Number>();
		private var _v_wise:uint = uint.MAX_VALUE;

		private var _vt:Vector.<Number> = new Vector.<Number>();
		private var _vt_wise:uint = uint.MAX_VALUE;

		private var _vn:Vector.<Number> = new Vector.<Number>();
		private var _vn_wise:uint = uint.MAX_VALUE;

		private var _f:Vector.<uint> = new Vector.<uint>();

		public function getVertices(flag:uint):Vector.<Number> {
			var result:Vector.<Number> = new Vector.<Number>();
			return result;
		}

		public function getIndices():Vector.<uint> {
			var result:Vector.<uint> = new Vector.<uint>();
			return result;
		}

		public function dispose():void {
			_v.length = 0;
			_v_wise = uint.MAX_VALUE;

			_vt.length = 0;
			_vt_wise = uint.MAX_VALUE;

			_vn.length = 0;
			_vn_wise = uint.MAX_VALUE;

			_f.length = 0;
		}
	}
}
