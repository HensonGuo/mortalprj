package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class Common extends Sprite
	{
		public function Common()
		{
			//http://192.168.10.183/test/
			var url1:String = "http://fr2cdn.xunwan.com/common/LocalObject.swf";
			var url:String = "LocalObject.swf";
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadCompleteHandler);
			loader.load(new URLRequest(url1),new LoaderContext(false,new ApplicationDomain()));
		}
		private var localObject:Object;
		private const NeedSpace:int = 3.14573e+007;
		
		private function onLoadCompleteHandler(event:Event):void
		{
			localObject = LoaderInfo(event.target).content as Object;
			var so:SharedObject = getLocal("xxxx");
			var state:String = so.flush(NeedSpace);
			writeFile("aaa","xxxx");
		}
		
		/**
		 * 读取本地文件 
		 * @param fileName
		 * @return 
		 * 
		 */		
		public function readFile( filePath:String ):Object
		{
			try
			{
				var so:SharedObject = getLocal(filePath);
				var file:Object =  so.data["fileName"];
				return file;
			}
			catch(e:Error)
			{
				
			}
			return null;
		}
		/**
		 * 写入本地文件 
		 * @param fileName
		 * @return 
		 * 
		 */		
		public function writeFile( filePath:String,file:Object ):Boolean
		{
			try
			{
				var so:SharedObject = getLocal(filePath);
				so.data["fileName"] = file;
				return true;
			}
			catch(e:Error)
			{
				
			}
			return false;
		}
		
		private function getLocal(name:String, localPath:String = null, secure:Boolean = false):SharedObject
		{
			return localObject.getLocal(name,localPath,secure);
		}
	}
}