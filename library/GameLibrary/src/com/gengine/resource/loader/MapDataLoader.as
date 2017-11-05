package com.gengine.resource.loader
{
	import com.fyGame.fyMap.FyMapInfo;
	
	import flash.utils.ByteArray;

	public class MapDataLoader extends BaseLoader
	{
		public function MapDataLoader()
		{
			super();
		}
		
		/**
		 * The loaded data. This will be null until loading of the resource has completed.
		 */
		public function get mapInfo():FyMapInfo
		{
			return _mapInfo;
		}
		
		override public function getClass():Class
		{
			return MapDataLoader;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize(data:*):void
		{
			if(!(data is ByteArray))
				throw new Error("DataResource can only handle ByteArrays.");
			
			var info:FyMapInfo = new FyMapInfo();
			info.read(data);
			_mapInfo = info;
			
			if( resourceInfo )
			{
				resourceInfo.data = _mapInfo;
			}
			onLoadCompleteHandler();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onContentReady(content:*):Boolean 
		{
			return _mapInfo != null;
		}
		
		private var _mapInfo:FyMapInfo = null;
	}
}