package com.gengine.modules
{
	import com.gengine.core.Singleton;
	import com.gengine.debug.Log;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	public class ModuleManager extends Singleton
	{
		private var _modulesMap:Dictionary = new Dictionary();
		
		private var _moduleList:Array = new Array();
		
		private static var _instance:ModuleManager;
		
		private var _tempModuleInfo:ModuleInfo;
		
		private var _isloading:Boolean = false;
		
		public static function get instance():ModuleManager
		{
			if( _instance == null )
			{
				_instance = new ModuleManager();
			}
			return _instance;
		}
		
		public function loadModuleInfo( infoList:Array ):void
		{
			var moduleInfo:ModuleInfo;
			for( var i:int = 0 ; i< infoList.length;i++ )
			{
				moduleInfo = infoList[i] as ModuleInfo;
				_modulesMap[ moduleInfo.url ] = moduleInfo;
			}
		}
		
		private function getModuleInfo(url:String):ModuleInfo
		{
			return _modulesMap[ url ] as ModuleInfo;
		}
		
		public function loadModule( url:String ):ModuleInfo
		{

			var info:ModuleInfo =  getModuleInfo(url) as ModuleInfo;
			if( info )
			{
				if( info.isLoaded )
				{
					loaderComplete(info)
				}
				else if( info.isLoading )
				{
					// 加载中 不做处理
				}
				else
				{
					_moduleList.push(info);
					info.isLoading = true;
					if( _isloading == false )
					{
						loadNextModule();
					}
				}
				return info;
			}
			else
			{
				throw new Error("没有该模块信息,请调用loadModuleInfo url="+url);
			}
			return null;
		}
		
		private function loadNextModule( context:LoaderContext = null ):void
		{
			var module:ModuleInfo = _moduleList.shift() as ModuleInfo;
			if( module )
			{
				_isloading = true;
				loadModuleImpl(module,context);
			}
			else
			{
				_isloading = false;
			}
		}
		
		/**
		 * 加载模块 
		 * @param info
		 * @param context
		 * 
		 */		
		private function loadModuleImpl( info:ModuleInfo ,context:LoaderContext = null):void
		{
			var loader:ModuleLoader = ObjectPool.getObject(ModuleLoader);
			
			loader.addEventListener(Event.COMPLETE,onCompleteHandler);
			loader.addEventListener(ProgressEvent.PROGRESS,onProgressHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onIoErrorHandler);
			
			loader.load(info.url,context);
		}
		
		/**
		 * 加载完成 
		 * @param info
		 * 
		 */		
		private function loaderComplete( info:ModuleInfo ):void
		{
			info.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		private function onCompleteHandler( event:Event ):void
		{
			var loader:ModuleLoader = event.target as ModuleLoader;
			
			loader.removeEventListener(Event.COMPLETE,onCompleteHandler);
			loader.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,onIoErrorHandler);
			
			var info:ModuleInfo = getModuleInfo(loader.url);
			
			info.isLoaded = true;
			info.isLoading = false;
			if( loader.content is IModule )
			{
				info.module = loader.content as IModule;
			}
			else
			{
				throw new Error("加载的不是模块，请实现IModule 接口");
			}
			loaderComplete(info);
			
			loadNextModule();
			
			_tempModuleInfo = null;
		}
		

		private function onProgressHandler( event:ProgressEvent ):void
		{
			var loader:ModuleLoader = event.target as ModuleLoader;
			var info:ModuleInfo = getModuleInfo(loader.url);
			if( info )
			{
				info.dispatchEvent(event);
			}
		}
		
		private function onIoErrorHandler( event:IOErrorEvent ):void
		{
			var loader:ModuleLoader = event.target as ModuleLoader;
			var info:ModuleInfo = getModuleInfo(loader.url);
			if( info )
			{
				info.dispatchEvent(event);
				info.error = true;
				info.isLoaded = false;
				info.isLoading = false;
			}
			loadNextModule();
			Log.system("ModuleManager:"+event.text);
		}
	}
}