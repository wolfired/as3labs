package idiot.codec {

	import flash.utils.IDataOutput;

	public interface IEncoder {
		function encode(raw:IDataOutput):void;
	}
}
