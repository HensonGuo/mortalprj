package mortal.game.resource
{
	import com.gengine.debug.Log;
	import com.gengine.resource.ConfigManager;
	import com.gengine.resource.FileType;
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.ResourceInfo;
	
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mortal.common.global.ParamsConst;
	import mortal.common.global.PathConst;
	import mortal.common.preLoadPage.PreloaderConfig;
	
	/**
	 * 资源路径配置 
	 * @author jianglang
	 * 
	 */	
	public class ResConfig
	{
		private static var _instance:ResConfig;
		
		private var _effectMap:Dictionary = new Dictionary();
		
		public function ResConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ResConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():ResConfig
		{
			if( _instance == null )
			{
				_instance = new ResConfig();
			}
			return _instance;
		}
		
		private function init():void
		{
			var memory:int = System.totalMemory;
			initEffect();
			var bytes:ByteArray =  ConfigManager.instance.getByteArrayByFileName("assets.vas");
			bytes.uncompress();
			bytes.position = 0;
			var dic:Object = bytes.readObject() as Object;
			for each (var obj:Object in dic)
			{
				break;
			}
			if(obj is Array)
			{
				newWrite(dic);
			}
			else
			{
				write( dic );
			}
			Log.system("系统总内存:",System.totalMemory,"解压Res内存增加:",System.totalMemory - memory);
		}
		
		private function initEffect():void
		{
			var bytes:ByteArray =  ConfigManager.instance.getByteArrayByFileName("effect.vas");
			bytes.uncompress();
			bytes.position = 0;
			var dic:Object = bytes.readObject() as Object;
			for (var effectName:String in dic)
			{
				_effectMap[effectName] = dic[effectName];
			}
		}
		
		private var _index:int;
		private var _length:int;
		private var _maxLength:int;
		
		/**
		 *  
		 * @param object
		 * @return 
		 * 
		 */		
		protected function write( dic:Object ):void
		{
			if(PreloaderConfig.preResName)
			{
				_maxLength = PreloaderConfig.preResName.length;
			}
			
			var ref:Class;
			var resInfo:ResourceInfo;
			for each( var o:Object in dic  )
			{
				ref = FileType.getLoaderInfoByType( o.type as String);
				if( ref )
				{
					resInfo =  new ref( o );
				}
				else
				{
					resInfo = new ResourceInfo( o );
				}
				
				resInfo.loaclPath = resInfo.path;
				resInfo.path = PathConst.mainPath + resInfo.path; 
				
				if(_maxLength > _length)
				{
					_index = PreloaderConfig.preResName.indexOf(resInfo.name);
					if(_index != -1)
					{
						resInfo.path = PreloaderConfig.preResUrl[_index].path + "?v=" + ParamsConst.instance.preLoaderVersion;
						resInfo.loaclPath = resInfo.path;
						resInfo.path = PathConst.mainPath + resInfo.path; 
						_length++;
					}
				}
				
				ResourceManager.addResource( resInfo );
			}
		}
		
		
		/**
		 *  
		 * @param object
		 * @return 
		 * 
		 */		
		protected function newWrite( dic:Object ):void
		{
			if(PreloaderConfig.preResName)
			{
				_maxLength = PreloaderConfig.preResName.length;
			}
			
			var ref:Class;
			var resInfo:ResourceInfo;
			var str:String;
			var index:int;
			//			var time:Number = new Date().time;
			//			trace("--------------开始解析----------");
			var arr:Array;
			for(var pathStr:String in dic)
			{
				arr = dic[pathStr];
				for each( var o:Object in arr  )
				{
					o.path =  pathStr+"/"+o.name;
					str = o.name ;
					index = str.lastIndexOf(".");
					str = str.slice(index);
					o.type = str;
					
					ref = FileType.getLoaderInfoByType( o.type as String);
					if( ref )
					{
						resInfo =  new ref( o );
					}
					else
					{
						resInfo = new ResourceInfo( o );
					}
					
					resInfo.loaclPath = resInfo.path;
					resInfo.path = PathConst.mainPath + resInfo.path; 
					
					if(_maxLength > _length)
					{
						_index = PreloaderConfig.preResName.indexOf(resInfo.name);
						if(_index != -1)
						{
							resInfo.path = PreloaderConfig.preResUrl[_index].path + "?v=" + ParamsConst.instance.preLoaderVersion;
							resInfo.loaclPath = resInfo.path;
							resInfo.path = PathConst.mainPath + resInfo.path; 
							_length++;
						}
					}
					
					ResourceManager.addResource( resInfo );
				}
			}
			//			trace("--------------结束解析---------耗时",new Date().time-time);
		}
		
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */		
		public function getInfoByName( name:String ):ResourceInfo
		{
			return ResourceManager.getInfoByName(name);
		}
		
		public function getUrlByName( name:String ):String
		{
			var info:ResourceInfo = ResourceManager.getInfoByName(name);
			if( info )
			{
				return info.path;
			}
			return "";
		}
		
		public function getEffectTemplateByName(url:String):String
		{
			if(!_effectMap[url])
			{
				return "";
			}
			return _effectMap[url];
		}
	}
}