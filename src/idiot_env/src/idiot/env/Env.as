package idiot.env {

	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * 全局/环境参数类
	 * 支持(优先级由高到低)：(页面)加载器传参，(页面)URL传参，(本地/远程)文件传参
	 *
	 * @includeExample MyEnv.as
	 */
	public class Env {

		public function Env() {
		}

		private const _args:Object = {};

		/**
		 * @param stage
		 * @param callback () => void
		 * @param cfg_url
		 */
		public final function setup(stage:Stage, callback:Function, cfg_url:String = "./cfg"):void {
			load(cfg_url, function(dat:String):void {
				if(null != dat && "" != dat) {
					var cfg_args:URLVariables = new URLVariables(dat);
					cover(cfg_args);
				}

				if(ExternalInterface.available) {
					dat = ExternalInterface.call("window.location.search.substring", 1);
					if(null != dat && "" != dat) {
						var url_args:URLVariables = new URLVariables(dat);
						cover(url_args);
					}
				}

				var swf_args:Object = stage.loaderInfo.parameters;
				cover(swf_args);

				callback();
			});
		}

		/**
		 * 显示默认参数列表
		 * @param separator 分隔符, "\n" or "&"
		 */		
		public final function print(separator:String = "\n"):void {
			const qname:String = getQualifiedClassName(this);
			const clazz:Class = getDefinitionByName(qname) as Class;
			const inst:Env = new clazz() as Env;

			var args:Vector.<String> = new Vector.<String>();

			for each(var accessor:XML in describeType(inst).accessor) {
				if("writeonly" == accessor.@access) {
					continue;
				}
				var key:String = accessor.@name;
				args.push(key + "=" + inst[key]);
			}

			args.sort(0);

			trace(args.join(separator));
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
			_args[key] = value;
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
	function onLoaded(event:Event):void {
		loader.removeEventListener(Event.COMPLETE, onLoaded);
		loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);

		callback(loader.data as String);
	}

	function onError(event:IOErrorEvent):void {
		loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		loader.removeEventListener(Event.COMPLETE, onLoaded);

		callback(null);
	}

	var loader:URLLoader = new URLLoader();
	loader.dataFormat = URLLoaderDataFormat.TEXT;
	loader.addEventListener(Event.COMPLETE, onLoaded);
	loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
	loader.load(new URLRequest(url));
}
