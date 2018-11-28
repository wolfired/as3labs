package idiot.flags {

	import flash.utils.ByteArray;
	import idiot.log.Log;
	import idiot.log.Logs;
	import idiot.pool.Pool;
	import idiot.signal.SignalRouter;
	import idiot.signal.terminal.SignalTerminal;

	public final class Flags {

		private static const _commands:Object = {};

		public static function register(command:Flags):void {

			_commands[command.name] = command;
		}

		public static function parse(input:String):void {

			input = input.replace(/^\s*/gs, "").replace(/\s*$/gs, "");
			const cmdname:String = input.match(/^\S+/gs)[0] as String;
			const command:Flags = _commands[cmdname];

			if(null == command) {

				Logs.ins.log("no command: " + cmdname, Log.LEVEL_WARN);
				return;
			}

			command.exec(input.substr(cmdname.length));
		}

		public function Flags(name:String, help:String) {

			_name = name;
			_help = help;

			_flags = {};
		}

		private var _name:String;
		private var _help:String;

		private var _flags:Object;

		public final function get name():String {
			return _name;
		}

		public final function get help():String {
			return _help;
		}

		/**
		 * @param name 参数名
		 * @param defval 默认值
		 * @param help 说明
		 * @param fn 回调函数 (flags:Flags) => uint
		 */
		public function addFlagBoolean(name:String, defval:Boolean, help:String, fn:Function = null):Flags {

			const f:FlagBoolean = new FlagBoolean();

			f.name = name;
			f.defval = defval;
			f.help = help;
			f.fn = fn;

			_flags[f.name] = f;

			return this;
		}

		public function getBoolean(name:String):Boolean {
			return (_flags[name] as FlagBoolean).curval;
		}

		public function setBoolean(name:String, value:Boolean):void {
			(_flags[name] as FlagBoolean).curval = value;
		}

		public function addFlagInt(name:String, defval:int, help:String):Flags {

			const f:FlagInt = new FlagInt();

			f.name = name;
			f.defval = defval;
			f.help = help;

			_flags[f.name] = f;

			return this;
		}

		public function getInt(name:String):int {
			return (_flags[name] as FlagInt).curval;
		}

		public function setInt(name:String, value:int):void {
			(_flags[name] as FlagInt).curval = value;
		}

		public function addFlagUint(name:String, defval:uint, help:String):Flags {

			const f:FlagUint = new FlagUint();

			f.name = name;
			f.defval = defval;
			f.help = help;

			_flags[f.name] = f;

			return this;
		}

		public function getUint(name:String):uint {
			return (_flags[name] as FlagUint).curval;
		}

		public function setUint(name:String, value:uint):void {
			(_flags[name] as FlagUint).curval = value;
		}

		public function addFlagNumber(name:String, defval:Number, help:String):Flags {

			const f:FlagNumber = new FlagNumber();

			f.name = name;
			f.defval = defval;
			f.help = help;

			_flags[f.name] = f;

			return this;
		}

		public function getNumber(name:String):Number {
			return (_flags[name] as FlagNumber).curval;
		}

		public function setNumber(name:String, value:Number):void {
			(_flags[name] as FlagNumber).curval = value;
		}

		public function addFlagString(name:String, defval:String, help:String):Flags {

			const f:FlagString = new FlagString();

			f.name = name;
			f.defval = defval;
			f.help = help;

			_flags[f.name] = f;

			return this;
		}

		public function getString(name:String):String {
			return (_flags[name] as FlagString).curval;
		}

		public function setString(name:String, value:String):void {
			(_flags[name] as FlagString).curval = value;
		}

		public function usage():void {
			var texts:Array = [];
			texts.push(_name + " - " + _help);

			var arr:Array = [];
			var f:Flag;

			for each(f in _flags) {

				arr.push({name: f.name});
			}

			arr.sortOn("name");

			for each(var o:Object in arr) {

				f = _flags[o.name] as Flag;

				texts.push("\t" + f.name + " - " + f.help);
			}

			SignalRouter.ins.route((Pool.ins.pull(SignalTerminal) as SignalTerminal).setup(SignalTerminal.PRINT, {texts: texts}));
		}

		private function exec(input:String):void {
			input = input.replace(/^\s*/gs, "");

			if(null == input || "" == input) {

				this.usage();

				return;
			}

			var i:int;

			var ss:Vector.<String> = new Vector.<String>();

			var bs:ByteArray = new ByteArray();

			var is_escape:Boolean = false;
			var in_quotes_d:Boolean = false;
			var in_quotes_s:Boolean = false;
			var cc:String;
			var end:Boolean = false;

			// socket -c -h "127.0.0.1" -p 8888
			// socket -c -h "'127.0.0.1'" -p 8888
			// socket -c -h '127.0.0.1' -p 8888
			// socket -c -h '"127.0.0.1"' -p 8888
			// socket -c -h 127.0.0.1 -p 8888
			for(i = 0; i < input.length; ++i) {
				cc = input.charAt(i);

				if(in_quotes_d) {
					if("\"" == cc) {
						end = true;
					}
				} else if(in_quotes_s) {
					if("'" == cc) {
						end = true;
					}
				} else {
					if("\t" == cc || "\n" == cc || "\r" == cc || " " == cc) {
						end = true;
					} else if(!in_quotes_s && "\"" == cc) {
						in_quotes_d = true;
					} else if(!in_quotes_d && "'" == cc) {
						in_quotes_s = true;
					}
				}

				if(end) {
					end = false;
					in_quotes_d = false;
					in_quotes_s = false;

					bs.position = 0;
					0 < bs.length && ss.push(bs.readUTFBytes(bs.length));
					bs.length = 0;
				} else if(in_quotes_d) {
					if("\"" != cc) {
						bs.writeUTFBytes(cc);
					}
				} else if(in_quotes_s) {
					if("'" != cc) {
						bs.writeUTFBytes(cc);
					}
				} else {
					bs.writeUTFBytes(cc);
				}
			}

			bs.position = 0;
			0 < bs.length && ss.push(bs.readUTFBytes(bs.length));
			bs.length = 0;

			var flag:Flag;

			for each(flag in _flags) {
				(flag is FlagBoolean) && this.setBoolean(flag.name, (flag as FlagBoolean).defval);
				(flag is FlagInt) && this.setInt(flag.name, (flag as FlagInt).defval);
				(flag is FlagUint) && this.setUint(flag.name, (flag as FlagUint).defval);
				(flag is FlagNumber) && this.setNumber(flag.name, (flag as FlagNumber).defval);
				(flag is FlagString) && this.setString(flag.name, (flag as FlagString).defval);
			}

			var name:String;
			var next:String;

			for(i = 0; i < ss.length; ++i) {

				name = ss[i].substr(1);
				next = ss.length > i + 1 ? ("-" == ss[i + 1].charAt(0) ? null : ss[i + 1]) : null;

				flag = _flags[name] as Flag;

				if(null == next) {

					(flag is FlagBoolean) && this.setBoolean(name, !(flag as FlagBoolean).defval);

				} else {

					(flag is FlagBoolean) && this.setBoolean(name, "true" == next);
					(flag is FlagInt) && this.setInt(name, int(parseInt(next)));
					(flag is FlagUint) && this.setUint(name, uint(parseInt(next)));
					(flag is FlagNumber) && this.setNumber(name, parseInt(next));
					(flag is FlagString) && this.setString(name, next);

					++i;
				}
			}

			var cmd:FlagBoolean;

			for each(flag in _flags) {

				cmd = flag as FlagBoolean;

				if(null == cmd || null == cmd.fn || !cmd.curval) {
					continue;
				}

				cmd.fn(this);
			}
		}
	}
}
