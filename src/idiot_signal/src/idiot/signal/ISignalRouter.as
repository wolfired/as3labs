package idiot.signal {

	public interface ISignalRouter {
		function addHandler(signal_id:uint, handler:Function):void;
		function delHandler(signal_id:uint, handler:Function):void;
		function clnHnadler(signal_id:uint):void;
		function route(signal:Signal):void;
	}
}
