package demo.entry {

	import demo.core.ins.modules;
	import demo.core.ins.stager;
	import demo.core.ins.thread_main;
	import demo.embed.ins.env_embed;
	import idiot.fetch.FetcherTask;
	import idiot.jobs.job.Job;
	import idiot.module.Module;
	import idiot.quick.ins.fetcher;
	import idiot.quick.ins.jobs_queue;
	import idiot.thread.Thread;

	public class ModuleEntry extends Module {

		/**
		 * @param args {stage:Stage}
		 */
		public function ModuleEntry(args:Object) {
			stager.stage = args.stage;

			this.boot(); //入口模块自启动
		}

		override protected function bootOther():void {
			jobs_queue.wait(new Job().setup(function(done:Function):void {
				//启动线程
				fetcher.fetch(env_embed.daemon, function(task:FetcherTask):void {
					var thread_sub0:Thread = thread_main.fork(task.raw);
					thread_sub0.start();
					thread_sub0.sender.channel.send("Hi, I am Main!");
					trace(thread_sub0.recver.channel.receive(true));

					done();
				});
			}));

			jobs_queue.wait(new Job().setup(function(done:Function):void {
				//启动控制台
				modules.boot("demo.terminal::ModuleTerminal");

				done();
			}));
		}
	}
}
