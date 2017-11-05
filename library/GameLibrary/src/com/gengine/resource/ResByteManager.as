/**
 * 管理缓存的byteArray 
 * @hexiaoming
 */
package com.gengine.resource
{
	import com.gengine.resource.info.ResourceInfo;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class ResByteManager
	{
		public static var _byteMap:Dictionary = new Dictionary();
		
		public static function addInfo(info:ResourceInfo):void
		{
			if(!_byteMap[info.name])
			{
				_byteMap[info.name] = info;
			}
		}
		
		/**
		 * 释放byteArray 
		 * 
		 */
		public static function dispose():void
		{
			var time:Number = getTimer();
			for each(var info:ResourceInfo in _byteMap)
			{
				if(info.bytesDisposeTime < time)
				{
					info.clearCacheBytes();
					delete _byteMap[info.name];
				}
			}
		}
	}
}