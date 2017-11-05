package com.gengine.resource
{
	import com.gengine.core.call.Caller;
	import com.gengine.core.frame.FlashFrame;
	import com.gengine.core.frame.FrameManager;
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.debug.Log;
	import com.gengine.manager.CacheManager;
	import com.gengine.resource.info.ResourceInfo;
	import com.gengine.resource.loader.BaseLoader;
	import com.gengine.resource.loader.LoaderErrorEvent;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;

	public class LoaderManager
	{
		private var _completeCaller:Caller;
		private var _progressCaller:Caller;
		private var _errorCaller:Caller;
		
		public var maxQueue:int = 8; //同时最多加载数量
		
		private var _queueMap:Dictionary; //队列MAP
		
		private var _currentCount:int=0; // 当前正在加载的数量
		
		private var _queueArray:Array;	// 加载 队列
		
		private var _highQueue:Array; //高级队列列表
		
		private var _frameQueue:Array;//当两个队列都为空时 处理的分帧加载列表 最优先加载
		
		private var _lastFrame:int;//上次加载的帧时间
		
		private var _timer:FrameTimer;//帧定时器
		
		private var _preloadingInfo:ResourceInfo;//正在预加载的资源
		
		private static var _instance:LoaderManager = new LoaderManager();
		
		public function LoaderManager()
		{
			if( _instance != null )
			{
				throw new Error("LoaderManager 单例  ");
			}
			_queueArray = [];
			_highQueue = [];
			_frameQueue = [];
			
			_completeCaller = new Caller();
			_progressCaller = new Caller();
			_errorCaller = new Caller();
			
			_timer = new FrameTimer(1,int.MAX_VALUE,true);
			_timer.addListener(TimerType.ENTERFRAME,onEnterFrame);
			_timer.start();
			
		}
		
		public static function get instance():LoaderManager
		{
			return _instance;
		}
		
		public function load( fileName:String,onLoaded:Function,loaderPriority:int = 3,extData:Object=null,onProgresse:Function = null, onFailed:Function = null ):ResourceInfo
		{
			var info:ResourceInfo = ResourceManager.getInfoByName(fileName);
			if( info == null )
			{
				Log.error( fileName + "==没有该文件" );
				if(onFailed is Function)
				{
					onFailed(info);
				}
			}else
			{
				loadInfo( info,onLoaded,loaderPriority,extData,onProgresse,onFailed );
			}
			
			return info;
		}
		
		/**
		 * 如果一个还未开始加载，则移除加载
		 * 
		 */
		public function removeNotLoadedFile(url:String):void
		{
			var resInfo:ResourceInfo;
			var i:int;
			for(i = 0;i < _queueArray.length;i++)
			{
				resInfo = _queueArray[i] as ResourceInfo;
				if(resInfo.name == url)
				{
					_queueArray.splice(i,1);
					resInfo.isLoading = false;
					resInfo.isLoaded = false;
					return;
				}
			}
			for(i = 0;i < _highQueue.length;i++)
			{
				resInfo = _highQueue[i] as ResourceInfo;
				if(resInfo.name == url)
				{
					_highQueue.splice(i,1);
					resInfo.isLoading = false;
					resInfo.isLoaded = false;
					return;
				}
			}
		}
		
//		public function loadImgUrl( url:String,onLoaded:Function,loaderPriority:int = 3,extData:Object=null,onProgresse:Function = null, onFailed:Function = null ):void
//		{
//			var info:ResourceInfo = ResourceManager.getInfoByName(url);
//			if( info == null )
//			{
//				info = new ImageInfo();
//			}
//			loadImpl( info,onLoaded,loaderPriority,extData,onProgresse,onFailed );
//		}
		
		
		public function loadInfo(  info:ResourceInfo,onLoaded:Function,loaderPriority:int = 3,extData:Object=null,onProgresse:Function = null, onFailed:Function = null  ):void
		{
			if(extData)
			{
				info.extData = extData;
			}
			
			if( info.isLoaded )
			{
				onLoaded(info);
				info.addReference();
				return;
			}
			else if( info.isLoading )
			{
				_completeCaller.addCall(info.name,onLoaded);
				
				if( onProgresse is Function )
				{
					_progressCaller.addCall(info.name,onProgresse);
				}
				
				if( onFailed is Function)
				{
					_errorCaller.addCall(info.name,onFailed);
				}
			}
			// 在预加载而且
			else if( info.isPreLoading )
			{
				if(!_preloadingInfo)
				{
					_preloadingInfo = info;
					
					_completeCaller.addCall(info.name,onLoaded);
					
					if( onProgresse is Function )
					{
						_progressCaller.addCall(info.name,onProgresse);
					}
					
					if( onFailed is Function)
					{
						_errorCaller.addCall(info.name,onFailed);
					}
					
					PreLoaderManager.instance.addLoadedCall(info.name,loadPreRes);
					PreLoaderManager.instance.addErrorCall(info.name,loadPreRes);
				}
			}
			else
			{
				_completeCaller.addCall(info.name,onLoaded);
				
				if( onProgresse is Function )
				{
					_progressCaller.addCall(info.name,onProgresse);
				}
				
				if( onFailed is Function)
				{
					_errorCaller.addCall(info.name,onFailed);
				}
				addLoader(info,loaderPriority);
			}
		}
		
		private function loadPreRes():void
		{
			if(_preloadingInfo)
			{
				
				loadResource(_preloadingInfo,true);
//				addLoader(_preloadingInfo,LoaderPriority.LevelA);
				_preloadingInfo = null;
			}
		}
		
		private function onEnterFrame( frame:FrameTimer):void
		{
			if(_frameQueue.length > 0)
			{
				var info:ResourceInfo = _frameQueue.shift();
				loaderInfo(info);
			}
		}
		
		private function canLoadResource( isForce:Boolean = false):Boolean
		{
			if( _currentCount < maxQueue || isForce)
			{
				//分帧加载  不要一次性加载最大数量
				return true;
			}
			return false;
		}
		
		private function loadResource(info:ResourceInfo,isForce:Boolean = false):Boolean
		{
			if(!canLoadResource(isForce))
			{
				return false;
			}
			var cls:Class = FileType.getLoaderByType(info.type);
			if( cls )
			{
				_currentCount++;
				info.isLoading = true;
				
				var currentFrame:int = (FrameManager.flashFrame as FlashFrame).rendererCount;
				if(_lastFrame == currentFrame)
				{
					_frameQueue.push(info);
				}
				else
				{
					_lastFrame = currentFrame;
					loaderInfo(info);
				}
			}
			else
			{
				info.isLoading = false;
				Log.debugLog.error(info.name+",不支持该类型文件");
				loadNext();
				//throw new Error("未知的文件类型");
				
			}
			return true;
		}
		private function loaderInfo(info:ResourceInfo):void
		{
			var cls:Class = FileType.getLoaderByType(info.type);
			
			if(cls)
			{
				var loader:BaseLoader = ObjectPool.getObject(cls);
				loader.addEventListener(Event.COMPLETE,onCompleteHandler);
				loader.addEventListener(ProgressEvent.PROGRESS,onProgressHandler);
				loader.addEventListener(LoaderErrorEvent.LoaderError,onIOErrorHandler);
				loader.load( info.path,info);
			}
		}
		
		/**
		 * 添加一个加载处理器 
		 * @param loaderElement
		 * 
		 */		
		private function addLoader( info:ResourceInfo,loaderPriority:int = 3 ):void
		{
			if( loadResource(info) == false )
			{
				addQueue( info ,loaderPriority );
				info.isLoading = true;
			}
		}
		
		private function addQueue( info:ResourceInfo,loaderPriority:int=0 ):void
		{
			//如果已经加载过对象，直接放到最高级
			if(info.isLoadedByteArray() || info.isHasLoaded )
			{
				loaderPriority = 0;
			}
			//最低级
			if( loaderPriority >= 3 )
			{
				_queueArray.push(info);
			}
			else if( loaderPriority == 0 ) //最高级
			{
				_highQueue.unshift(info);
			}
			else if( loaderPriority == 1)
			{
				_highQueue.push(info);
			}
			else if( loaderPriority == 2 )
			{
				_queueArray.unshift(info);
			}
		}
		
		private function shiftQueue():ResourceInfo
		{
			if( _highQueue.length > 0 )
			{
				return _highQueue.shift() as ResourceInfo;
			}
			else if( _queueArray.length > 0 )
			{
				return _queueArray.shift() as ResourceInfo;
			}
			return null;
		}
		
		/**
		 * 加载完成 
		 * @param event
		 * 
		 */		
		private function onCompleteHandler( event:Event ):void
		{
			_currentCount --;
			var loader:BaseLoader = event.target as BaseLoader;
			loader.removeEventListener(Event.COMPLETE,onCompleteHandler);
			loader.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler);
			loader.removeEventListener(LoaderErrorEvent.LoaderError,onIOErrorHandler);
			
			if( loader.resourceInfo )
			{
				loader.resourceInfo.addReference();
				_completeCaller.call(loader.resourceInfo.name,loader.resourceInfo);
				_completeCaller.removeCallByType(loader.resourceInfo.name);
				_progressCaller.removeCallByType(loader.resourceInfo.name);
				_errorCaller.removeCallByType(loader.resourceInfo.name);
				if(_dicReference.hasOwnProperty(loader.resourceInfo.name))
				{
					delete _dicReference[loader.resourceInfo.name];
				}
			}
			loader.dispose();
			ObjectPool.disposeObject(loader);
			
			loadNext();
		}
		
		/**
		 * 加载下一个资源 
		 * 
		 */		
		private function loadNext():void
		{
			if(_frameQueue.length > 0)
			{
				return;
			}
			if( canLoadResource())
			{
				if(_highQueue.length > 0 )
				{
					loadResource( _highQueue.shift() as ResourceInfo )
				}
				else if( _queueArray.length > 0)
				{
					loadResource( _queueArray.shift() as ResourceInfo )
				}
			}
			else if(!_preloadingInfo)
			{
				PreLoaderManager.instance.start();
			}
		}
		
		/**
		 * 加载进度 
		 * @param event
		 * 
		 */		
		private function onProgressHandler( event:ProgressEvent ):void
		{
			var loader:BaseLoader = event.target as BaseLoader;
			if( loader.resourceInfo )
			{
				_progressCaller.call(loader.resourceInfo.name,event);
			}
		}
		/**
		 * 加载异常 
		 * @param event
		 * 
		 */		
		private function onIOErrorHandler( event:LoaderErrorEvent ):void
		{
			_currentCount --;
			var loader:BaseLoader = event.target as BaseLoader;
			if( loader.resourceInfo )
			{
				loader.resourceInfo.path += "_1";
				loader.resourceInfo.dispose();
				_errorCaller.call(loader.resourceInfo.name,loader.resourceInfo);
				_completeCaller.removeCallByType(loader.resourceInfo.name);
				_progressCaller.removeCallByType(loader.resourceInfo.name);
				_errorCaller.removeCallByType(loader.resourceInfo.name);
				CacheManager.instance.deleteVersion(loader.resourceInfo.name);
				Log.error( "LoaderManager.onIOErrorHandler ->"+event.text );
			}
			
			loader.dispose();
			ObjectPool.disposeObject(loader);
			loadNext();
		}
		/**
		 * 删除资源加载事件 
		 * @param file
		 * @param onLoaded
		 * @param onProgresse
		 * @param onFailed
		 * 
		 */		
		public function removeResourceEvent(file:String,onLoaded:Function,onProgresse:Function = null, onFailed:Function = null ):void
		{
			if( onLoaded is Function )
			{
				_completeCaller.removeCall(file,onLoaded);
			}
			if( onProgresse is Function )
			{
				_progressCaller.removeCall(file,onProgresse);
			}
			if( onFailed is Function )
			{
				_errorCaller.removeCall(file,onFailed);
			}
		}
		
		public function isLoading():Boolean
		{
			return _currentCount != 0;
		}
		
		public function disposeFile(fileName:String):void
		{
			var info:ResourceInfo = ResourceManager.getInfoByName(fileName)	;
			if( info )
			{
				info.dispose();
			}
		}	
		
		//加载计数, 引用计数为0是可移除加载  加载过的资源不做此优化
		private var _dicReference:Dictionary = new Dictionary();
		
		public function addReference(fileName:String):void
		{
			var info:ResourceInfo = ResourceManager.getInfoByName(fileName);
			if(info && info.isHasLoaded)
			{
				return;
			}
			if(_dicReference.hasOwnProperty(fileName))
			{
				_dicReference[fileName] ++;
			}
			else
			{
				_dicReference[fileName] = 1;
			}
		}
		
		/**
		 * 移除引用，如果引用为0，如果从未加载,则清除加载
		 * @param fileName
		 * 
		 */
		public function removeReference(fileName:String):void
		{
			if(_dicReference.hasOwnProperty(fileName) )
			{
				var info:ResourceInfo = ResourceManager.getInfoByName(fileName);
				if(info && !info.isHasLoaded)
				{
					_dicReference[fileName] --;
					if(_dicReference[fileName] == 0)
					{
						clearLoadFile(fileName);
					}
				}
			}
		}
		
		/**
		 * 清除加载 
		 * @param fileName
		 * 
		 */
		public function clearLoadFile(fileName:String):void
		{
			var index:int = _queueArray.indexOf(fileName);
			if(index != -1)
			{
				_queueArray.splice(index,1);
			}
			else
			{
				index = _highQueue.indexOf(fileName);
				_highQueue.splice(index,1);
			}
		}
	}
}