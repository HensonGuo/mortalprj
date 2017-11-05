package com.gengine.resource
{
	import com.gengine.resource.info.ResourceInfo;
	import com.gengine.resource.loader.BaseLoader;
	import com.gengine.resource.loader.LoaderErrorEvent;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;

	public class SpecialLoaderManager
	{
		/**
		 * 加载其他资源的管理器 （不在assets配置路径的） 
		 * 
		 */		
		public function SpecialLoaderManager()
		{
			
		}
		
		public static function Load(resName:String,path:String,onLoaded:Function,loaderPriority:int = 3,extData:Object=null,onProgresse:Function = null, onFailed:Function = null):void
		{
			var resInfo:ResourceInfo;
			if(ResourceManager.hasInfoByName(resName))
			{
				resInfo = ResourceManager.getInfoByName(resName);
			}
			else
			{
				var ref:Class;
				//获取文件类型
				var ary:Array = path.split(".");
				var type:String = ary[ary.length - 1];
				type = "." + type.toLocaleUpperCase();
				
				var obj:Object = new Object();
				obj.type = type;
				obj.name = resName;
				obj.time = Math.random().toString();
				obj.path = path;
				
				ref = FileType.getLoaderInfoByType( obj.type as String);
				if( ref )
				{
					resInfo =  new ref( obj );
				}
				else
				{
					resInfo = new ResourceInfo( obj );
				}
				resInfo.loaclPath = resInfo.path;
				
				ResourceManager.addResource( resInfo );
			}
			
			LoaderManager.instance.load(resName,onLoaded,loaderPriority,extData,onProgresse,onFailed);
		}
	}
}