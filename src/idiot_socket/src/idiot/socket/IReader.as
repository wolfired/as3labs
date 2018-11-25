package idiot.socket {

	import flash.utils.IDataInput;

	public interface IReader {
		function read(di:IDataInput):Boolean;
	}
}
