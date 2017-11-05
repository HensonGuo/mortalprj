package com.gengine.resource
{
	import com.gengine.core.Singleton;
	import com.gengine.resource.info.ResourceInfo;
	
	import flash.system.System;
	import flash.utils.Dictionary;

	public class ResourceManager
	{
		private static var _resourceNameMap:Dictionary = new Dictionary();
//		private static var _resourceUrlMap:Dictionary = new Dictionary();
		
		private static var _instance:ResourceManager;
		
		
		public static function addResource( resource:ResourceInfo ):void
		{
			_resourceNameMap[resource.name] = resource;
//			_resourceUrlMap[resource.path] = resource;
		}
		
		public static function removeResource( resource:ResourceInfo ):void
		{
			delete _resourceNameMap[resource.name];
//			delete _resourceUrlMap[resource.path];
		}
		
		public static function getInfoByName(name:String):ResourceInfo
		{
			return _resourceNameMap[name] as ResourceInfo;
		}
		
		public static function hasInfoByName( name:String ):Boolean
		{
			return name in _resourceNameMap;
		}
		
		public static function disposeAll():void
		{
			for each( var info:ResourceInfo in _resourceNameMap)
			{
				info.dispose();
			}
			System.gc();
		}
		
//		public static function getInfoByUrl(url:String):ResourceInfo
//		{
//			return _resourceUrlMap[url] as ResourceInfo;
//		}
	}
}