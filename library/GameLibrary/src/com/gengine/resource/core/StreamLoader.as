package com.gengine.resource.core
{
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.resource.info.ResourceInfo;
	import com.gengine.resource.loader.LoaderErrorEvent;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	[Event(name="error",type="flash.events.ErrorEvent")]
	
	public class StreamLoader extends EventDispatcher
	{
		private var _url:String;
		
		private var _urlLoader:URLLoader;
		
		private var _contentType:String;
		
		private var _loaderInfo:LoaderInfo;
		
		protected var _resourceInfo:ResourceInfo;
		
		//最后一次收到进度的信息  用于重新加载，最多10次
		private var _isNeedReload:Boolean = true;
		
		protected var _verifyTime:int;
		
		protected var _reloadTimes:int = 0;//已经重新加载的次数
		
		private var _maxReloadTimes:int = 10;//重新加载的最大次数
		
		private var _reloadSec:int = 10;//重新加载的时间
		
		public function StreamLoader()
		{
			
		}
		
		public function get isNeedReload():Boolean
		{
			return _isNeedReload;
		}

		public function set isNeedReload(value:Boolean):void
		{
			_isNeedReload = value;
		}

		public function get reloadSec():int
		{
			return _reloadSec;
		}

		public function set reloadSec(value:int):void
		{
			_reloadSec = value;
		}

		public function get maxReloadTimes():int
		{
			return _maxReloadTimes;
		}

		public function set maxReloadTimes(value:int):void
		{
			_maxReloadTimes = value;
		}

		public function get resourceInfo():ResourceInfo
		{
			return _resourceInfo;
		}
		
		/**
		 * 加载资源 
		 * @param url
		 * @param context
		 * 
		 */
		public function load( url:String,info:ResourceInfo ):void
		{
			_resourceInfo = info;
			_url = url;
			initLoader();
		}
		
		private function initLoader():void
		{
			if(_url)
			{
				//			if( _urlLoader == null )
				//			{
				_urlLoader = new URLLoader();
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				//			}
				//			else
				//			{
				//				_urlLoader.removeEventListener(Event.COMPLETE,onCompleteHandler);
				//				_urlLoader.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler);
				//				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
				//				_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOError);
				//			}
				_urlLoader.addEventListener(Event.COMPLETE,onCompleteHandler);
				_urlLoader.addEventListener(ProgressEvent.PROGRESS,onProgressHandler);
				_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
				_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOError);
				_urlLoader.load( new URLRequest( _url ) );
			}
//			verifyTime();
		}
		
		protected function removeLoadEvent():void
		{
			clearVerifyTime();
			try
			{
				_urlLoader.removeEventListener(Event.COMPLETE,onCompleteHandler);
				_urlLoader.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
				_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOError);
				_urlLoader.close();
			}catch(e:Error){};
		}
		
		protected function onCompleteHandler( event:Event ):void
		{
			removeLoadEvent();
			
			_urlLoader = null;
			
			streamloadComplete(event.target.data);
			
			initialize( event.target.data );
			
		}
		
		protected function streamloadComplete( data:* ):void
		{
			
		}
		
		/**
		 * 进度事件 
		 * @param event
		 * 
		 */
		protected function onProgressHandler( event:ProgressEvent ):void
		{
			dispatchEvent(event);
			if(_isNeedReload)
			{
				verifyTime();
			}
		}
		
		/**
		 * 验证时间 
		 * 
		 */		
		private function verifyTime():void
		{
			//10秒没更新加载进度就重新加载
			clearVerifyTime();
			_verifyTime = setTimeout(reload,_reloadSec * 1000);
		}
		
		private function clearVerifyTime():void
		{
			if(_verifyTime)
			{
				clearTimeout(_verifyTime);
				_verifyTime = 0;
			}
		}
		
		private function reload():void
		{
			_reloadTimes++;
			clearVerifyTime();
			stop();
			if(_reloadTimes < _maxReloadTimes)
			{
				Log.debug(_url + "重新加载" + _reloadTimes + "次");
				initLoader();
			}
			else
			{
				Log.error(_url + "重新加载失败");
				onIOError(new ErrorEvent("重新加载失败"));
			}
		}
		
		/**
		 * 加载器 异常
		 * @param event
		 * 
		 */		
		private function onIOError( event:ErrorEvent ):void
		{
			removeLoadEvent();
			
			onIOErrorHandler(event);
			
		}
		
		protected function onIOErrorHandler( event:ErrorEvent ):void
		{
			Log.system( event.text );
			dispatchEvent(new LoaderErrorEvent( event.text ));
		}
		
		protected var loadedByteArray:ByteArray;
		
		public function initialize(data:*):void
		{
			if( !(data is ByteArray) )
			{
				throw new Error("Default Resource can only process ByteArrays!");
			}
			loadedByteArray = data as ByteArray;
			StreamManager.pushIn(this);
		}
		
		public function loadByteArray():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onChangeIOErrorHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onChangeIOErrorHandler);
			loader.loadBytes(loadedByteArray);
			loadedByteArray = null;
		}
		
		protected function onContentReady( content:* ):Boolean
		{
			return true;
		}
		
		/**
		 * 加载 并 转换完成 
		 * @param event
		 * 
		 */		
		private function onLoadComplete( event:Event ):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			_loaderInfo = loaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onChangeIOErrorHandler);
			loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onChangeIOErrorHandler);
			
			if( onContentReady( event?event.target.content:null ) )
			{
				//				_urlLoader.close();
				//_urlLoader = null;
				onLoadCompleteHandler();
			}
		}
		
		protected function onLoadCompleteHandler():void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * 转换器 失败 
		 * @param event
		 * 
		 */		
		protected function onChangeIOErrorHandler( event:IOErrorEvent ):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onChangeIOErrorHandler);
			loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onChangeIOErrorHandler);
			
			onIOErrorHandler(event);
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		public function dispose():void
		{
			stop();
			clearVerifyTime();
			_resourceInfo = null;
			_url = null;
			_loaderInfo = null;
			_reloadTimes = 0;
			_reloadSec = 10;
			_maxReloadTimes = 10;
			_isNeedReload = true;
			//			_urlLoader = null;
		}
		
		public function get url():String
		{
			return _url;
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
		
		public function stop():void
		{
			if( _urlLoader )
			{
				_urlLoader.removeEventListener(Event.COMPLETE,onCompleteHandler);
				_urlLoader.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
				_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOError);
				try
				{	
					if( _urlLoader.bytesLoaded != _urlLoader.bytesTotal )
					{
						_urlLoader.close();
					}
				}
				catch(e:Error){};
			}
		}
	}
}