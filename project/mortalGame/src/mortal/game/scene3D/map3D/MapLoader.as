package mortal.game.scene3D.map3D
{
	import com.fyGame.fyMap.FyMapInfo;
	import com.gengine.debug.Log;
	import com.gengine.debug.ThrowError;
	import com.gengine.resource.loader.MapDataLoader;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	
	import mortal.game.Game;
	import mortal.game.resource.SceneConfig;
	import mortal.game.scene3D.map3D.util.GameSceneUtil;
	import mortal.game.scene3D.map3D.util.MapFileUtil;

//	import mortal.game.resource.SceneConfig;
	
	[Event(name="complete",type="flash.events.Event")]
	public class MapLoader extends EventDispatcher
	{
		private static var _instance:MapLoader = new MapLoader();
		
		private var _maploader:MapDataLoader;
		
		private var _sceneloader:URLLoader;
		
		private var _isMaploaded:Boolean = false;
		private var _isMapLoading:Boolean = false;
		
		private var _isSceneLoaded:Boolean = false;
		
		
		private var _mapDic:Dictionary = new Dictionary();
		private var _sceneDic:Dictionary = new Dictionary();
		
		public function MapLoader()
		{
//			_maploader = 
			//_sceneloader = new URLLoader();
		}
		
		public static function get instance():MapLoader
		{
			return _instance;
		}
		
		public function LoadSceneInfo():void
		{
		}
		
		/**
		 * 加载当天所在地图的地图数据 
		 * 
		 */		
		public function load():void
		{
			var mapInfo:FyMapInfo = _mapDic[ MapFileUtil.mapID ];
			if( mapInfo == null )
			{
				if( _maploader )
				{
					_maploader.removeEventListener(Event.COMPLETE,onMapLoadedHandler);
				}
				_maploader = new MapDataLoader();
				_isMaploaded = false;
				_isMapLoading = true;
				_maploader.addEventListener(Event.COMPLETE,onMapLoadedHandler);
				_maploader.load(MapFileUtil.mapDataPath,null);
			}
			else
			{
				Game.mapInfo = mapInfo;
				_isMaploaded = true;
				onCompleteHandler();
			}
		}
		
		private function onMapLoadedHandler( event:Event ):void
		{
			var mapLoader:MapDataLoader = event.target as MapDataLoader;
			mapLoader.removeEventListener(Event.COMPLETE,onMapLoadedHandler);
			Log.debug("服务器地图ID:"+MapFileUtil.mapID);
			Log.debug("配置文件地图ID:"+mapLoader.mapInfo.mapId);
			if( mapLoader.mapInfo.mapId != MapFileUtil.mapID)
			{
				ThrowError.show("地图ID:服务器ID:"+MapFileUtil.mapID+"|配置数据ID:"+mapLoader.mapInfo.mapId)
				if( mapLoader.mapInfo.mapId == 0 )
				{
					mapLoader.mapInfo.mapId = MapFileUtil.mapID;
				}
			}
//			_maploader.mapInfo.mapId = MapFileUtil.mapID;
			Game.mapInfo = _maploader.mapInfo;
			_mapDic[ MapFileUtil.mapID ] = mapLoader.mapInfo;
			_isMaploaded = true;
			_isMapLoading = false;
			onCompleteHandler();
		}
		
		/**
		 * 加载某张地图的地图数据 
		 * @param mapId
		 * 
		 */		
		public function loadMapData(mapId:int, callBack:Function = null):void
		{
			var mapInfo:FyMapInfo = _mapDic[ mapId ];
			if( mapInfo == null )
			{
				var _mapIdLoader:MapDataLoader = new MapDataLoader();
				_mapIdLoader.addEventListener(Event.COMPLETE,onMapIdLoadedHandler);
				_mapIdLoader.load(MapFileUtil.getMapDataPathByMapId(mapId),null);
			}
			else
			{
				if(callBack != null)
				{
					callBack(mapInfo);
				}
			}
			
			function onMapIdLoadedHandler(event:Event):void
			{
				var mapLoader:MapDataLoader = event.target as MapDataLoader;
				mapLoader.removeEventListener(Event.COMPLETE,onMapIdLoadedHandler);
				_mapDic[ mapId ] = mapLoader.mapInfo;
				
				if(callBack != null)
				{
					callBack(mapLoader.mapInfo);
				}
			}
		}
		
		/**
		 * 返回地图数据 
		 * @param mapId
		 * @return 
		 * 
		 */		
		public function getMapData(mapId:int):FyMapInfo
		{
			return _mapDic[ mapId ] as FyMapInfo;
		}
		
//		private function onSceneLoadedHandler( event:Event ):void
//		{
//			_sceneloader.removeEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
//			_sceneloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOErrorHandler);
//			_sceneloader.removeEventListener(Event.COMPLETE,onSceneLoadedHandler);
//			
//			Game.sceneInfo.readObj( JSON.deserialize(_sceneloader.data) );
//			_isSceneLoaded = true;
//			onCompleteHandler();
//		}
		
		private function onIOErrorHandler( event:ErrorEvent ):void
		{
			Log.system("MapLoader:"+event.text);
		}
		
		public function stop():void
		{
			if( _maploader )
			{
				_maploader.removeEventListener(Event.COMPLETE,onMapLoadedHandler);
				_maploader.stop();
			}
			_isMaploaded = false;
			_isMapLoading = false;
		}
		
		private function onCompleteHandler():void
		{
			Game.sceneInfo = SceneConfig.instance.getSceneInfo(MapFileUtil.mapID);
			GameSceneUtil.sceneInfo = Game.sceneInfo;
			dispatchEvent(new Event( Event.COMPLETE ));
		}
	}
}
