package mortal.game.resource
{
	import com.gengine.core.Singleton;
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.info.GMapBgInfo;
	import mortal.game.resource.info.GMapInfo;

	public class GameMapConfig extends Singleton
	{
		private static var _instance:GameMapConfig;
		
		private var _mapBg:Dictionary;
		
		private var _map:Dictionary;
		
		private var _mapVersion:Dictionary;
		
		private var _npcMap:Dictionary;
		
		public function GameMapConfig()
		{
			_mapBg = new Dictionary();
			_map = new Dictionary();
			_npcMap = new Dictionary();
			_mapVersion = new Dictionary();
			init();
		}
		
		public static function get instance():GameMapConfig
		{
			if( _instance == null )
			{
				_instance = new GameMapConfig();
			}
			return _instance;
		}
		
		public function getVersionById( mapID:int  ):String
		{
			return _mapVersion[mapID];
		}
		
		/**
		 * 返回场景信息 
		 * @param mapId
		 * @param int
		 * @return 
		 * 
		 */
		public function getMapInfo(mapId:int):GMapInfo
		{
			return _map[mapId];
		}
		
		/**
		 * 组织数据写入map
		 * @param object
		 * @return 
		 * 
		 */		
		private function write( dic:Object ):void
		{
			var bgInfo:GMapBgInfo;
			var info:GMapInfo;
			var o:Object;
			//解析背景图
			var bgMaps:Object = dic.bgMaps;
			var maps:Object = dic.maps;
			for each( o in bgMaps.bgMap  )
			{
				bgInfo = new GMapBgInfo();
				bgInfo.mapName = o.id;
				bgInfo.mapWidth = o.mapWidth;
				bgInfo.mapHeight = o.mapHeight;
				bgInfo.version = o.version;
				_mapBg[bgInfo.mapName] = bgInfo;
			}
			//解析地图
			for each( o in maps.map  )
			{
				info = new GMapInfo();
				info.id = o.id;
				info.name = o.name;
				info.hasBossPoint = o.hasBossPoint;
				info.version = o.version;
				info.des = o.des;
				info.mapscene = o.mapscene;
				info.bgInfo = _mapBg[o.bgMap];
				_mapVersion[ info.id ] = info.version;
				
				info.copyid= o.copyid;
				_map[info.id] = info;
				if( o.hasOwnProperty("npc") )
				{
					if( o.npc is Array )
					{
						for each( var npc:Object in o.npc )
						{
							addNPCToType(info.id,npc);
						}
					}
					else if( o.npc is Object )
					{
						addNPCToType(info.id,o.npc);
					}
				}
			}
		}
		/**
		 * <npc type="DragNPC" npcId="1000234,1000238,1000242"/> 
		 * @param npc
		 * 
		 */		
		private function addNPCToType( mapid:int , npc:Object ):void
		{
			if( npc == null ) return;
			var ary:Array = _npcMap[ npc.type ];
			if( ary == null )
			{
				_npcMap[ npc.type ] = ary = [];
			}
			ary.push( {id:mapid,text:npc.npcId } );
		}
		
		public function getNpcByType( type:String ):Array
		{
			return _npcMap[type];
		}
		
		/**
		 * 读出数据 
		 * 
		 */
		public function init():void
		{
			var object:Object = ConfigManager.instance.getObjectByFileName("gameMap.xml");
			write( object );
		}
		
	}
}