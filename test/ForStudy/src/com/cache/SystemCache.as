package com.cache
{
	import com.gengine.resource.loader.SWFLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class SystemCache
	{
		private static var systemCache:SystemCache;
		
		private var _dic:Dictionary = new Dictionary();
		public var faceSWF:SWFLoader;
		
		public function SystemCache()
		{
			faceSWF = new SWFLoader();
			faceSWF.load("assets/IM/face/face.swf");
		}
		
		public static function getInstance():SystemCache
		{
			if(!systemCache)
			{
				systemCache = new SystemCache();
			}
			return systemCache;
		}
		
		public function addToDic(str:String,view:Sprite):void
		{
			_dic[str] = view;
		}
		
		public function getView(name:String):Sprite
		{
//			if(_dic.hasOwnProperty(name))
			return _dic[name] as Sprite;
//			else return null;
		}
	}
}