package com.gengine.resource.info
{
	import com.fyGame.fyMap.FyMapInfo;

	public class MapDataInfo extends ResourceInfo
	{
		private var _mapInfo:FyMapInfo;
		
		public function MapDataInfo(object:Object)
		{
			super(object);
		}
		
		public function get mapInfo():FyMapInfo
		{
			return _mapInfo;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			_mapInfo = value as FyMapInfo ;
		}
	}
}