package idiot.env {

	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	import flash.utils.describeType;

	/**
	 * 全局/环境参数类
	 * 支持(优先级由高到低)：(页面)加载器传参，(页面)URL传参，(本地/远程)文件传参
	 * 
	 * @includeExample MyEnv.as
	 */
	public class IdiotEnv {

		public function IdiotEnv() {
		}

		private var _args:Object = {};

		/**
		 * @param stage
		 * @param callback () => void
		 * @param cfg_url
		 */
		public final function setup(stage:Stage, callback:Function, cfg_url:String = "./cfg"):void {
			load(cfg_url, function(dat:String):void {
				if(null != dat) {
					var cfg_args:URLVariables = new URLVariables(dat);
					cover(cfg_args);
				}

				if(ExternalInterface.available) {
					var url_args:URLVariables = new URLVariables(ExternalInterface.call("window.location.search.substring", 1));
					cover(url_args);
				}

				var swf_args:Object = stage.loaderInfo.parameters;
				cover(swf_args);

				callback();
			});
		}

		/**
		 * 在调IdiotEnv.setup之前调用本方法，显示默认参数列表
		 * @return 参数列表
		 */
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

		private function cover(args:Object):void {
			for(var key:String in args) {
				_args[key] = args[key];
			}
		}
	}
}

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

/**
 * @param url
 * @param callback (dat:String = null) => void
 */
function load(url:String, callback:Function):void {
	var onLoaded:Function = function(event:Event):void {
		loader.removeEventListener(Event.COMPLETE, onLoaded);
		loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);

		callback(loader.data as String);
	};

	var onError:Function = function(event:IOErrorEvent):void {
		loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		loader.removeEventListener(Event.COMPLETE, onLoaded);

		callback(null);
	};

	var loader:URLLoader = new URLLoader(new URLRequest(url));
	loader.dataFormat = URLLoaderDataFormat.TEXT;
	loader.addEventListener(Event.COMPLETE, onLoaded);
	loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
}
