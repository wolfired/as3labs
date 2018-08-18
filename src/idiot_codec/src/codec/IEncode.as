package codec {

	import flash.utils.ByteArray;

	public interface IEncode {
		function encode(raw:ByteArray):void;
	}
}
