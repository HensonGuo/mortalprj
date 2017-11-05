package frEngine.loaders.resource.info.image{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class Image extends EventDispatcher 
	{
		protected var imageWidth:int;
		protected var imageHeight:int;
		protected var data:Array;
		public static var ONLOADCOMPLETE:String="loadcomplete";

		public function Image()
		{
			
		}
		public function getData():Array 
		{
           return data;
        }
		public function getWidth():int
		{
			return imageWidth ;
		}
		public function getHeight():int
		{
			return imageHeight ;
		}
		public function getDataLength():int {
            return data.length;
		}
		public function load(filename:String):void
		{
			var request:URLRequest = new URLRequest(filename);
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onLoad);
			loader.load(request);
		}
		public function onLoad(event:Event,stream:ByteArray=null):void
		{
			//override by its child!
		}
	}
}