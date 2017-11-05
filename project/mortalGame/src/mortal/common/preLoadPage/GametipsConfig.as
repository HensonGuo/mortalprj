/**
 * @date 2011-6-30 上午10:01:29
 * @author  陈炯栩
 * 
 */

package mortal.common.preLoadPage
{
	import com.gengine.debug.Log;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class GametipsConfig
	{
		private static var _instance:GametipsConfig;
		
		private var _intervalTime:int = 3;
		private var _tips:Array;
		
		public function GametipsConfig()
		{
			if(_instance)
			{
				throw new Error("GametipsConfig 单例！");
			}
		}
		
		public static function get instance():GametipsConfig
		{
			if(!_instance)
			{
				_instance = new GametipsConfig();
			}
			return _instance;
		}
		
		public function get intervalTime():int
		{
			return _intervalTime;
		}
		
		/**
		 * 加载小提示配置资源
		 * 
		 * */
		public function load(urlReq:URLRequest,success:Function):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,onLoaderComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onLoaderError);
			loader.load(urlReq);
			
			function onLoaderComplete(e:Event):void
			{
				var xml:XML = new XML((e.target as URLLoader).data);
				
				_intervalTime = parseInt(xml.child("intervalTime").@value);
				
				_tips = new Array();
				for each(var item:XML in xml.child("item"))
				{
					_tips.push(String(item.@value));
				}
				
				success.call();
			}
			
			function onLoaderError(e:IOErrorEvent):void
			{
				Log.system("Gametips.xml 加载失败！");
			}
		}
		
		/**
		 * 获得一个随机的小提示
		 * 
		 * */
		public function getRandomTip():String
		{
			if(_tips && _tips.length >= 1)
			{
				var index:int = Math.round((_tips.length-1) * Math.random());
				return _tips[index] as String;
			}
			return "";
		}
	}
}