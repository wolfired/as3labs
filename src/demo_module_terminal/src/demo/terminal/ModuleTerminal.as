package demo.terminal {

	import demo.core.ins.signal_router;
	import demo.core.ins.stager;
	import demo.core.ins.terminal;
	import demo.core.signal.SignalTerminal;
	import idiot.module.Module;
	import idiot.signal.Signal;

	public class ModuleTerminal extends Module {
		public function ModuleTerminal() {
		}

		override protected function bootSelf():void {
		}

		override protected function bootOther():void {
			signal_router.addHandler(SignalTerminal.OPEN, function(signal:Signal):void {
				terminal.open(stager.stage);
			});

			signal_router.addHandler(SignalTerminal.CLOSE, function(signal:Signal):void {
				terminal.close();
			});

			signal_router.route(new SignalTerminal().setup(SignalTerminal.OPEN, {}));
		}
	}
}
