package codec {

	import flash.utils.ByteArray;

	public interface IDecode {
		function decode(raw:ByteArray):void;
	}
}
