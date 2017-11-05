package com.gengine.resource.loader
{
	import com.gengine.resource.ResByteManager;
	import com.gengine.resource.core.StreamLoader;
	import com.gengine.resource.info.ResourceInfo;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;

	public class BaseLoader extends StreamLoader
	{
		public var data:*;
		
		public function getClass():Class
		{
			return BaseLoader;
		}
		
		override public function load(url:String, info:ResourceInfo):void
		{
			
			if( info )
			{
				var bytes:ByteArray = info.cacheBytes;
				if( bytes )
				{
					_resourceInfo = info;
					initialize(bytes);
					return;
				}
			}
			super.load(url,info);
		}
		
		override protected function streamloadComplete( data:* ):void
		{
			if( _resourceInfo )
			{
				_resourceInfo.cacheBytes = data;
			}
		}
		
		public function BaseLoader( )
		{
			super();
		}
		
		override protected function onIOErrorHandler(event:ErrorEvent):void
		{
			if( _resourceInfo )
			{
				_resourceInfo.isLoaded = false;
				_resourceInfo.isLoading = false;
			}
			super.onIOErrorHandler(event);
		}
		
		override protected function onLoadCompleteHandler():void
		{
			if(_resourceInfo )
			{
				_resourceInfo.isLoaded = true;
				_resourceInfo.isLoading = false;
				_resourceInfo.isHasLoaded = true;
				_resourceInfo.resetDisposeTime();
				ResByteManager.addInfo(_resourceInfo);
			}
			super.onLoadCompleteHandler();
		}
	}
} 