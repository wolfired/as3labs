package demo.terminal {

	import flash.system.System;
	import idiot.fetch.Fetcher;
	import idiot.fetch.FetcherTask;
	import idiot.flags.Flags;
	import idiot.module.Module;
	import idiot.module.Modules;
	import idiot.pool.Pool;
	import idiot.signal.SignalRouter;
	import idiot.signal.socket.SignalSocket;
	import idiot.signal.thread.SignalThread;
	import idiot.stager.Stager;
	import idiot.terminal.Terminal;

	public class ModuleTerminal extends Module {
		public function ModuleTerminal() {
		}

		override protected function booting():void {
			super.booting();
		}

		override protected function booted():void {
			super.booted();

			Flags.register(new Flags("system", "系统命令").addFlagBoolean("gc", false, "垃圾回收", function(flags:Flags):uint {System.gc();return 0;}));

			Flags.register(new Flags("socket", "网络命令")
						   .addFlagBoolean("c", false, "连接服务器", function(flags:Flags):void {SignalRouter.ins.route((Pool.ins.pull(SignalSocket) as SignalSocket).setup(SignalSocket.CONNECT, {host: flags.getString("h"), port: flags.getInt("p")}));})
						   .addFlagBoolean("d", false, "断开服务器", function(flags:Flags):void {SignalRouter.ins.route((Pool.ins.pull(SignalSocket) as SignalSocket).setup(SignalSocket.DISCONNECT, null));})
						   .addFlagString("h", "127.0.0.1", "主机")
						   .addFlagInt("p", 8888, "端口"));

			Flags.register(new Flags("module", "模块命令")
						   .addFlagBoolean("l", false, "模块列表")
						   .addFlagBoolean("i", false, "加载模块", function(flags:Flags):void {const n:String = flags.getString("n");null != n && "" != n && Modules.singleton.boot(n);})
						   .addFlagBoolean("u", false, "卸载模块")
						   .addFlagString("n", null, "模块名"));

			Flags.register(new Flags("thread", "线程命令")
						   .addFlagBoolean("l", false, "线程列表")
						   .addFlagBoolean("c", false, "创建线程", function(flags:Flags):void {Fetcher.ins.fetch(flags.getString("swf"), function(task:FetcherTask):void {SignalRouter.ins.route((Pool.ins.pull(SignalThread) as SignalThread).setup(SignalThread.CREATE, {bs: task.raw}));});})
						   .addFlagBoolean("s", false, "启动线程", function(flags:Flags):void {SignalRouter.ins.route((Pool.ins.pull(SignalThread) as SignalThread).setup(SignalThread.START, {tid: flags.getUint("tid")}));})
						   .addFlagBoolean("t", false, "停止线程")
						   .addFlagString("swf", null, "")
						   .addFlagUint("tid", uint.MAX_VALUE, "线程ID"));

			Terminal.open(Stager.singleton.stage);
		}

		override protected function halting():void {
			super.halting();
		}

		override protected function halted():void {
			super.halted();
		}
	}
}
