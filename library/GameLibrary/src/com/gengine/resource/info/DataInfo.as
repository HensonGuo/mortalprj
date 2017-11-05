package com.gengine.resource.info
{
	import flash.utils.ByteArray;

	public class DataInfo extends ResourceInfo
	{
		protected var _byteArray:ByteArray;
		
		public function DataInfo(object:Object)
		{
			super(object);
		}
		
		public function get byteArray():ByteArray
		{
			return _byteArray;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			_byteArray = value as ByteArray;
		}
		
		override public function clearCacheBytes():void
		{
			super.clearCacheBytes();
			_byteArray = null;
		}
	}
}