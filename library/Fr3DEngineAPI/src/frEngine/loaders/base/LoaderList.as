package frEngine.loaders.base
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import frEngine.event.ParamsEvent;

	public class LoaderList extends EventDispatcher
	{
		private var _loaders:URLLoader=new URLLoader();
		private var _loaderList:Array=new Array();
		private var _curLoadParams:Object;
		private var _isLoading:Boolean;
		public function LoaderList()
		{
			super();
			_loaders.dataFormat=URLLoaderDataFormat.BINARY;
			_loaders.addEventListener(Event.COMPLETE, this.loaded);
		}
		public function addFile(_url:String,_params:Array):void
		{
			if(_loaderList.indexOf(_url)==-1)
			{
				_loaderList.push({url:_url,params:_params});
			}
			loadNext();
		}
		private function loaded(e:Event,_bytes:ByteArray=null):void
		{
			if(e)
			{
				_bytes=e.currentTarget.data;
			}
			this.dispatchEvent(new ParamsEvent("ItemLoaded",[_bytes,_curLoadParams]));
			_isLoading=false;
			loadNext();
		}
		private function loadNext():void
		{
			if(_isLoading || _loaderList.length==0)
			{
				return;
			}
			_isLoading=true;
			var obj:Object=_loaderList.shift();
			_curLoadParams=obj.params;
			var _url:String=obj.url;
			_loaders.load(new URLRequest(_url));
		}
	}
}