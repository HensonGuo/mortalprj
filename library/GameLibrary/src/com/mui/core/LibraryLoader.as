package com.mui.core
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class LibraryLoader extends Loader
	{
		private var _request:URLRequest;
		
		public function LibraryLoader()
		{
			super();
		}
		
		override public function load(request:URLRequest, context:LoaderContext=null):void
		{
			_request = request;
			super.load(request,context);
		}

		public function get request():URLRequest
		{
			return _request;
		}

		public function getUrl():String
		{
			if(_request)
			{
				return _request.url;
			}
			return "";
		}
		
	}
}