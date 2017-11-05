package com.gengine.manager
{
	/**
	 * 本地缓存类 主要保存游戏中加载资源 
	 *  
	 * 一个文件保存一个 sol文件 这样不会导致一次读取 和 写入数据量太大
	 * 
	 * 初始化
	 * CacheManager.instance.initCache();
	 * 
	 * CacheManager.instance.setLocalCache();调用这个方法调出设置缓存大小
	 * 
	 * 
	 * path 是保存到 缓存的路径 也就是  SharedObject.getLocal(path) 中的path值
	 * 
	 * CacheManager.instance.readObject(fileName,version,path); 读取缓存中是否存在该文件缓存 
	 * 
	 * CacheManager.instance.writeObject(fileName,version,object,path); 写入数据到缓存
	 */	
	import com.gengine.core.Singleton;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class CacheManager extends Singleton
	{
		private static var _instance:CacheManager;
		
		private var _sharedObject:SharedObject;
		
		private const NeedSpace:int = 3.14573e+007;
		
		private var _versionData:Object = {};  //版本数据 保存了 {v:,n:} 版本+文件名
		
		private var _memoryData:Object = {};//本地缓存到内存数据
		
		private const CacheName:String = "frxz2Cache"; //缓存名称
		
		private const CachePath:String= "/frxz2/frxz2Cache"; //缓存路径
		
		private var _isCache:Boolean = false; //是否缓存
		
		private const Delay:int = 500; //延时保存缓存时间
		
		private var _saveTimer:Timer;
		
		private var _saveList:Array = []; //要保存的数据队列
		
		private var localObject:Object;
		
		private var _writeNum:int = 0; //写入次数
		
		public function CacheManager()
		{
			super();
		}
		
		public function get isCache():Boolean
		{
			return _isCache;
		}
		
		public function setLocalCache():void
		{
			initCache();
			setCache(true);
		}

		private function setCache(value:Boolean):void
		{
			getSharedObject();
			if( _sharedObject )
			{
				try
				{
					_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
					var state:String = _sharedObject.flush(NeedSpace);
					if (state != SharedObjectFlushStatus.PENDING) // 
					{
						_sharedObject.data["isCache"] = true;
						_isCache = true;
					}
					else
					{
						_sharedObject.data["isCache"] = false;
						_isCache = false;
					}
				}
				catch(e:Error)
				{
					_isCache = false;
					Security.showSettings(SecurityPanel.LOCAL_STORAGE);
				}
			}
			
		}

		public static function get instance():CacheManager
		{
			if( _instance == null )
			{
				_instance = new CacheManager();
			}
			return _instance;
		}
		
		private function getSharedObject():SharedObject
		{
			if( _sharedObject  == null)
			{
				try
				{
					_sharedObject = getLocal(CachePath);
					_versionData = _sharedObject.data[CacheName];
					_isCache = _sharedObject.data["isCache"];
				}
				catch(e:Error)
				{
					_isCache = false;
				}
				if( _versionData == null )
				{
					_versionData = {};
				}
			}
			return _sharedObject;
		}
		
		public function initCache():void
		{
			getSharedObject();
			if( _saveTimer == null )
			{
				_saveTimer = new Timer(Delay);
				_saveTimer.addEventListener(TimerEvent.TIMER, onTimerHandler);
			}
		}
		
		public function getLocal(name:String, localPath:String = null, secure:Boolean = false):SharedObject
		{
			return SharedObject.getLocal(name,"/",secure);
		}
		
		/**
		 * 定时写入文件 
		 * @param event
		 * 
		 */		
		private function onTimerHandler(event:TimerEvent):void
		{
			if( _saveList.length > 0)
			{
				var version:Object = _saveList.shift();
//				var file:Object = readMemory(version.n);
//				if( file )
//				{
					if( writeFile(version.n,version.data,version.path) == false )
					{
						deleteVersion(version.n);
					}
					else
					{
						setVersion( version.n, version.v);
						_writeNum ++;
					}
//				}
				
			}
			else
			{
				if( _saveTimer.running )
				{
					_saveTimer.stop();
				}
			}
		}
		/********************************************************
		 * 
		 * 外部接口文件操作+版本操作
		 * 
		 * *******************************************************/
		
		public function setVersion(fileName:String,version:String):void
		{
			_versionData[fileName] = version;
			if(_sharedObject)
			{
				_sharedObject.data[CacheName] = _versionData;
			}
		}
		
		private function getVersion(fileName:String):String
		{
			return _versionData[fileName];
		}
		
		public function deleteVersion(fileName:String):void
		{
			delete _versionData[fileName];
			if(_sharedObject)
			{
				_sharedObject.data[CacheName] = _versionData;
			}
		}
		
		/********************************************************
		 * 
		 * 外部接口文件操作+版本操作
		 * 
		 * *******************************************************/
		
		/**
		 * 根据文件名和版本获取对象
		 * @param fileName
		 * @param version
		 * @param path
		 * @return 
		 * 
		 */		
		public function readObject(fileName:String,version:String,path:String = null):Object
		{
			if( _isCache )
			{
				var v:String = getVersion(fileName);
				if( v == version )
				{
					return readFile(fileName,path);
				}
				return null;
			}
			return null;
		}
		/**
		 * 根据文件名和版本写入对象
		 * @param fileName
		 * @param version
		 * @param object
		 * @param path
		 * 
		 */		
		public function writeObject(fileName:String,version:String,object:Object,path:String = null):void
		{
			if( _isCache )
			{
				_saveList.push({n:fileName,v:version,data:object,path:path});
				startTimer();
			}
		}
		
		private function startTimer():void
		{
			if( _saveTimer.running == false )
			{
				_saveTimer.start();
			}
		}
		
		/********************************************************
		 * 
		 * 缓存文件操作
		 * 
		 * *******************************************************/
		/**
		 * 缓存操作  写入 读取 删除 
		 * @param fileName
		 * @param file
		 * 
		 */		
		private function writeMemory( fileName:String, file:Object ):void
		{
			_memoryData[fileName] = file;
		}
		
		private function readMemory( fileName:String ):Object
		{
			return _memoryData[fileName];
		}
		
		private function deleteMemory( fileName:String ):void
		{
			delete _memoryData[fileName];
		}
		
		/********************************************************
		 * 
		 * 本地文件操作
		 * 
		 * *******************************************************/
		/**
		 * 读取本地文件 
		 * @param fileName
		 * @return 
		 * 
		 */		
		private function readFile( fileName:String,path:String = null):Object
		{
			if( path == null ) path = fileName;
			try
			{
				var so:SharedObject = getLocal(path);
				var file:Object =  so.data[fileName];
				return file;
			}
			catch(e:Error){	}
			return null;
		}
		/**
		 * 写入本地文件 
		 * @param fileName
		 * @return 
		 * 
		 */		
		private function writeFile( fileName:String,file:Object,path:String = null ):Boolean
		{
			if( file == null ) return false;
			if( path == null ) path = fileName;
			try
			{
				var so:SharedObject = getLocal(path);
				so.data[fileName] = file;
				return true;
			}
			catch(e:Error){	}
			return false;
		}
		
		
		public function clear():void
		{
			_saveList.length = 0;
			_memoryData = {};
			_versionData ={};
			_sharedObject.data[CacheName] = _versionData;
			_sharedObject.flush();
			_saveTimer.stop();
		}
		
		private function onNetStatusEvent(e:NetStatusEvent):void 
		{
			if (e.info.code == "SharedObject.Flush.Failed") 
			{
				_isCache = false;
				clear();
			} 
			else 
			{
				_sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
				_isCache = true;
			}
			_sharedObject.data["isCache"] = _isCache;
		}
		
		public function flush():void
		{
			if( _isCache && _writeNum > 0 )
			{
				_writeNum = 0;
				if( _sharedObject )
				{
					_sharedObject.flush();
				}
			}
		}
	}
}