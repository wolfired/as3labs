package idiot.quick.ins {

	import idiot.jobs.Jobs;
	import idiot.jobs.scheduler.QueueScheduler;
	import idiot.jobs.trigger.FrameTrigger;

	public const jobs_queue:Jobs = new Jobs(new FrameTrigger(), new QueueScheduler());
}
