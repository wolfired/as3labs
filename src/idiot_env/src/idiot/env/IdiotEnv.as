package idiot.env {

	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	import flash.utils.describeType;

	/**
	 * 全局/环境配置类
	 */
	public class IdiotEnv {

		public function IdiotEnv(stage:Stage) {
			if(ExternalInterface.available) {
				var url_args:URLVariables = new URLVariables(ExternalInterface.call("window.location.search.substring", 1));
				this.extract(url_args);
			}

			var swf_args:Object = stage.loaderInfo.parameters;
			this.extract(swf_args);
		}

		private var _args:Object = {};

		public final function format():String {
			var args:Vector.<String> = new Vector.<String>();

			for each(var accessor:XML in describeType(this).accessor) {
				if("writeonly" == accessor.@access) {
					continue;
				}
				var key:String = accessor.@name;
				args.push(key + "=" + this[key]);
			}

			args.sort(0);

			return args.join("\n");
		}

		protected final function saveBoolean(key:String, value:Boolean):void {
			this.saveString(key, value.toString());
		}

		protected final function loadBoolean(key:String, value:Boolean):Boolean {
			var saved:String = this.loadString(key, null);
			return null == saved || "" == saved ? value : "true" == saved;
		}

		protected final function saveInt(key:String, value:int):void {
			this.saveString(key, value.toString());
		}

		protected final function loadInt(key:String, value:int):int {
			var saved:String = this.loadString(key, null);
			return null == saved || "" == saved ? value : parseInt(saved) as int;
		}

		protected final function saveUint(key:String, value:uint):void {
			this.saveString(key, value.toString());
		}

		protected final function loadUint(key:String, value:uint):uint {
			var saved:String = this.loadString(key, null);
			return null == saved || "" == saved ? value : parseInt(saved) as uint;
		}

		protected final function saveNumber(key:String, value:Number):void {
			this.saveString(key, value.toString());
		}

		protected final function loadNumber(key:String, value:Number):Number {
			var saved:String = this.loadString(key, null);
			return null == saved || "" == saved ? value : parseInt(saved);
		}

		protected final function saveString(key:String, value:String):void {
			_args[key] = _args[key] as String || value;
		}

		protected final function loadString(key:String, value:String):String {
			return _args[key] as String || value;
		}

		private function extract(args:Object):void {
			for(var key:String in args) {
				_args[key] = args[key];
			}
		}
	}
}
