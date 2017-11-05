package com.gengine.modules
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * 加载项 
	 * @author jianglang
	 * 
	 */	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	[Event(name="io_error",type="flash.events.IOErrorEvent")]
	[Event(name="init",type="flash.events.Event")]
	
	public class ModuleLoader extends EventDispatcher
	{
		private var _url:String;
		
		private var _loader:Loader;
		
		private var _contentType:String;
		
		private var _loaderInfo:LoaderInfo;
		
		protected var _appDomain:ApplicationDomain;
		
		public function ModuleLoader()
		{
			super();
		}
		/**
		 * 加载资源 
		 * @param url
		 * @param context
		 * 
		 */
		public function load( url:String ,context:LoaderContext=null ):void
		{
			if( _url != url )
			{
				_url = url;
				if( _loader == null )
				{
					_loader = new Loader();
				}
				else
				{
					_loader.contentLoaderInfo.removeEventListener(Event.INIT,onInitHandler);
					_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onCompleteHandler);
					_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler);
					_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
				}
				_loader.contentLoaderInfo.addEventListener(Event.INIT,onInitHandler);
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteHandler);
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgressHandler);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
				_loader.load(new URLRequest( _url ),context);
			}
		}
		
		private function onInitHandler( event:Event ):void
		{
			_loaderInfo = _loader.contentLoaderInfo;
			_appDomain = _loaderInfo.applicationDomain;
		}
		
		private function onCompleteHandler( event:Event ):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.INIT,onInitHandler);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onCompleteHandler);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
			dispatchEvent(event);
		}
		
		private function onProgressHandler( event:ProgressEvent ):void
		{
			dispatchEvent(event);
		}
		
		private function onIOErrorHandler( event:IOErrorEvent ):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		public function dispose():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.INIT,onInitHandler);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onCompleteHandler);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
			_loader.unload();
			_loader = null;
			_url = null;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get content():DisplayObject
		{
			if( _loaderInfo )
			{
				return _loaderInfo.content;
			}
			return null;
		}
		
		public function get contentType():String
		{
			if( _loaderInfo )
			{
				return _loaderInfo.contentType;
			}
			return null;
		}
		
		public function get loaderInfo():LoaderInfo
		{
			return _loaderInfo;
		}
		
		public function getExportedAsset(name:String):Object 
		{
			if (null == _appDomain) 
			{
				throw new Error("not initialized");
			}
			var assetClass:Class = getAssetClass(name);
			if (assetClass != null)
			{
				return new assetClass();
			}
			return null;
		}
		
		public function getAssetClass(name:String):Class
		{          
			if (null == _appDomain) 
			{
				throw new Error("not initialized");
			}
			if ( _appDomain.hasDefinition(name) )
			{
				return _appDomain.getDefinition(name) as Class;
			}
			return null;
		}
		
		
	}
}