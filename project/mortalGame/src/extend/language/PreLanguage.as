package extend.language
{
	import com.gengine.debug.Log;
	import com.mui.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import mortal.common.global.ParamsConst;
	import mortal.common.global.PathConst;
	import mortal.common.global.ProxyType;

	public class PreLanguage
	{
		public static const GotoGame:String = "正在进入游戏... ";
		
		private static var map:Object = new Object();
		
		public function PreLanguage()
		{
			
		}
		
		public static function init(onLoaded:Function):void
		{
			var path:String = PathConst.mainPath + "assets/config/preLanguage.json" + "?v=" + ParamsConst.instance.flashVersion;
			var urlReq:URLRequest = new URLRequest(path);
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE,onLoaderComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onLoaderError);
			loader.load(urlReq);
			
			function onLoaderComplete(e:Event):void
			{
				map = com.mui.serialization.json.JSON.deserialize((e.target as URLLoader).data as String);
				onLoaded.call();
			}
			
			function onLoaderError(e:IOErrorEvent):void
			{
				Log.system(path + " 加载失败！");
			}
		}
		
		
		public static function getString( code:int ):String
		{
			return map[code];
		}
		
		
	}
}