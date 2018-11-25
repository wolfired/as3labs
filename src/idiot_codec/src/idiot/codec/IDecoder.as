package idiot.codec {

	import flash.utils.IDataInput;

	public interface IDecoder {
		function decode(raw:IDataInput):void;
	}
}
