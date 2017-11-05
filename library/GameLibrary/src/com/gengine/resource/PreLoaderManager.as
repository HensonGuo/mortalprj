package com.gengine.resource
{
	import com.gengine.core.call.Caller;
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.manager.CacheManager;
	import com.gengine.resource.info.ResourceInfo;
	import com.gengine.resource.loader.BaseLoader;
	import com.gengine.resource.loader.LoaderErrorEvent;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class PreLoaderManager extends EventDispatcher
	{
		private var _urlLoader:URLLoader;
		
		private var _isLoading:Boolean = false;
		
		private var _completeCaller:Caller;
		
		private var _errorCaller:Caller;
		
		private var _currentResInfo:ResourceInfo;
		
		private var _queueArray:Array;	 // 加载队列
		
		private static var _instance:PreLoaderManager = new PreLoaderManager();
		
		public function PreLoaderManager()
		{
			if( _instance != null )
			{
				throw new Error("LoaderManager 单例  ");
			}
			_queueArray = [];
			_completeCaller = new Caller();
			_errorCaller = new Caller();
			_urlLoader = new URLLoader();
		}
		
		public static function get instance():PreLoaderManager
		{
			return _instance;
		}
		
		public function start():void
		{
			loadNext();
		}
		
		public function preLoad( fileName:String,extData:Object=null ):void
		{
			var info:ResourceInfo = ResourceManager.getInfoByName(fileName);
			if( info == null )
			{
				Log.error( fileName + "==没有该文件" );
				return ;
			}
			if(extData)
			{
				info.extData = extData;
			}
			
			if( info.isLoaded || info.isLoading || info.isAddToPreLoad)
			{
				return;
			}
			else
			{
				addQueue(info);
			}
		}
		
		private function loadResource( info:ResourceInfo ):Boolean
		{
			if( !LoaderManager.instance.isLoading() && !_isLoading)
			{
				_isLoading = true;
				info.isPreLoading = true;
				_currentResInfo = info;
				
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_urlLoader.addEventListener(Event.COMPLETE,onCompleteHandler);
				_urlLoader.addEventListener(ProgressEvent.PROGRESS,onProgressHandler);
				_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
				_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOError);
				_urlLoader.load( new URLRequest( info.path ) );
				return true;
			}
			return false;
		}
		
		/**
		 * 添加一个加载处理器 
		 * @param loaderElement
		 * 
		 */		
		private function addQueue( info:ResourceInfo ):void
		{
			info.isAddToPreLoad = true;
			if( loadResource(info) == false )
			{
				_queueArray.push(info);
			}
		}
		
		protected function loadNext():void
		{
			if( _queueArray.length > 0 )
			{
				var info:ResourceInfo = _queueArray[0] as ResourceInfo;
				if(info.isLoaded || info.isLoading)
				{
					_queueArray.shift();
					loadNext();
				}
				else
				{
					if(loadResource(info))
					{
						_queueArray.shift();
					}
				}
			}
		}
		
		protected function onCompleteHandler( event:Event ):void
		{
			try
			{
				_urlLoader.removeEventListener(Event.COMPLETE,onCompleteHandler);
				_urlLoader.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
				_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOError);
				_urlLoader.close();
			}catch(e:Error){};
			
			if( _currentResInfo )
			{
				_currentResInfo.cacheBytes = event.target.data;
			}
			
			_isLoading = false;
			_currentResInfo.isPreLoading = false;
			_completeCaller.call(_currentResInfo.name);
			
			loadNext();
		}
		
		/**
		 * 进度事件 
		 * @param event
		 * 
		 */
		protected function onProgressHandler( event:ProgressEvent ):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * 加载器 异常
		 * @param event
		 * 
		 */		
		private function onIOError( event:ErrorEvent ):void
		{
			_urlLoader.removeEventListener(Event.COMPLETE,onCompleteHandler);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOError);
			
			onIOErrorHandler(event);
			
			_currentResInfo.isPreLoading = false;
			_errorCaller.call(_currentResInfo.name);
			
			loadNext();
		}
		
		protected function onIOErrorHandler( event:ErrorEvent ):void
		{
			Log.system( event.text );
			if(Global.isDebugModle)
			{
				dispatchEvent(new LoaderErrorEvent( event.text ));
			}
		}
		
		public function addLoadedCall(resName:String,callBack:Function):void
		{
			_completeCaller.addCall(resName,callBack);
		}
		
		public function addErrorCall(resName:String,callBack:Function):void
		{
			_errorCaller.addCall(resName,callBack);
		}

		/**
		 * 正在加载的资源 
		 * @return 
		 * 
		 */		
		public function get preloadingInfo():ResourceInfo
		{
			if(_currentResInfo && _currentResInfo.isPreLoading)
			{
				return _currentResInfo;
			}
			return null;
		}

		
	}
}