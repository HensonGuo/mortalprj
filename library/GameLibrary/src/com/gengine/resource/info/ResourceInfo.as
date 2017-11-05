package com.gengine.resource.info
{
	import com.gengine.core.ClassProxy;
	import com.gengine.manager.CacheManager;
	
	import flash.display.LoaderInfo;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	public class ResourceInfo extends ClassProxy
	{	
		public static var resCount:Number = 0;
		
		public static const ReleaseByteTime:Number = 3 * 60 * 1000;//资源释放时间4分钟
		
		protected var loaderInfo:LoaderInfo;
		
		public var name:String; // 名称
		
		public var time:String;	// 时间
		
		public var path:String; // 路径
		
		public var type:String; //类型
		
		private var _data:Object; // 数据
		
		public var extData:Object;// 扩展属性
		
		public var isHasLoaded:Boolean = false;//是否曾今加载过
		
		public var isLoaded:Boolean; // 是否加载
		
		public var isLoading:Boolean = false; //是否正在加载
		
		public var isAddToPreLoad:Boolean = false;//是否已经在预加载 列表
		
		public var isPreLoading:Boolean = false;//是否当前正在预加载中
		
		private var _loadCacheBytes:ByteArray = null;//缓存的byteArray
		
		private var _referenceCount:int = 0;
		
		private var _isDispose:Boolean = false;
		
		private var _bytesDisposeTime:Number = 0;//清除byteArray的时间
		
		public var loaclPath:String;
		
		private var _soPath:String = null;
		
		
		public function ResourceInfo( object:Object = null )
		{
			if( object )
			{
				//write(object);
				this.type = object.type;
				this.name = object.name;
				this.time = object.time;
				this.path = object.path + "?v="+object.time;
//				Log.system(path);
			}
		}
		
		/**
		 * 加载这个资源 
		 * 
		 */
		public function resetDisposeTime():void
		{
			_bytesDisposeTime = getTimer() + ReleaseByteTime;
		}
		
		public function get soPath():String
		{
			if( _soPath == null )
			{
				if( loaclPath )
				{
					var index:int = loaclPath.lastIndexOf("?")
					if( index> -1 )
					{
						_soPath = loaclPath.slice(0,index)
					}
					else
					{
						_soPath = loaclPath;
					}
				}
				else
				{
					_soPath = "";
				}
			}
			return _soPath;
		}

		public function get isDispose():Boolean
		{
			return _isDispose;
		}

//		public function get data():Object
//		{
//			return _data;
//		}

		public function set data(value:Object):void
		{
			_data = value;
			_isDispose = false;
			
			//设置数据之后不需要要byteArray了
//			_loadCacheBytes = null;
		}

		public function addReference():void
		{
			_referenceCount ++;
		}
		
		public function removeReference():void
		{
			_referenceCount --;
		}
		
		public function get referenceCount():int
		{
			return _referenceCount;
		}
		/**
		 * 销毁整个对象 
		 * 
		 */		
		public function dispose():void
		{
			_isDispose = true;
			_data = null;
			_referenceCount = 0;
			isLoaded = false;
			isLoading = false;
			extData = null;
//			_loadCacheBytes = null;
			if( loaderInfo && loaderInfo.loader)
			{
				unload(loaderInfo);
				loaderInfo = null;
			}
		}
		
		protected function unload(loaderInfo:LoaderInfo):void
		{
			try
			{
				loaderInfo.loader.close();
			}catch(e:Error){};
//			loaderInfo.bytes.clear();
			loaderInfo.loader.unload();
		}
		
		
		public function isLoadedByteArray():Boolean
		{
			if(_loadCacheBytes)
			{
				return true;
			}
			return false;
		}
		
		public function get cacheBytes():ByteArray
		{
			if(_loadCacheBytes)
			{
				return _loadCacheBytes;
			}
			if( loaderInfo )
			{
				writeCacheBytes(loaderInfo.bytes);
			}
			else
			{
				_loadCacheBytes = CacheManager.instance.readObject(name,time,soPath) as ByteArray;
			}
			return _loadCacheBytes;
		}
		
		public function set cacheBytes( value:ByteArray ):void
		{
			writeCacheBytes(value);
			resCount += _loadCacheBytes.length;
			CacheManager.instance.writeObject(name,time,value,soPath);
		}
		
		public function clearCacheBytes():void
		{
			if(_loadCacheBytes)
			{
//				resCount -= _loadCacheBytes.length;
				_loadCacheBytes = null;
			}
		}
		
		private function writeCacheBytes( bytes:ByteArray ):void
		{
			_loadCacheBytes = bytes;
//			if( _loadCacheBytes == null )
//			{
//				_loadCacheBytes = new ByteArray();
//				_loadCacheBytes.position = 0;
//				_loadCacheBytes.writeBytes(bytes);
//			}else
//			{
//				_loadCacheBytes.clear();
//				_loadCacheBytes.position = 0;
//				_loadCacheBytes.writeBytes(bytes);
//			}
		}

		public function get bytesDisposeTime():Number
		{
			return _bytesDisposeTime;
		}

		
	}
}