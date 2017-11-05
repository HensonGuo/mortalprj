/**
 * 怪物配置
 */
package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TBoss;
	import Message.DB.Tables.TBossRefresh;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.StringHelper;
	
	import flash.utils.Dictionary;

	public class BossConfig
	{
		private static var _instance:BossConfig;
		
		private var _map:Dictionary = new Dictionary();
		private var _refresh:Dictionary  = new Dictionary();
		
		public function BossConfig()
		{
			if( _instance != null )
			{
				throw new Error(" BossConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():BossConfig
		{
			if( _instance == null )
			{
				_instance = new BossConfig();
			}
			return _instance;
		}
		
		/**
		 *  
		 * @param object
		 * @return 
		 * 
		 */		
		private function write( dic:Object ):void
		{
			var info:TBoss;
			for each( var o:Object in dic  )
			{
				info = new TBoss();
				
				info.code = o.code;
				
				info.name = StringHelper.getString(o.name);
				
				info.level = o.level;
				
				info.attackMode = o.attackMode;
				
				info.type = o.type;
				
				info.avatarId = o.avatarId;
				
				info.mesh = o.mesh;
				
				info.bone = o.mesh;
				
				info.texture = o.texture;
				
				info.speed = o.speed;
				
				info.maxLife = o.maxLife;
				
				info.maxMana = o.maxMana;
				
				info.modelScale = o.modelScale;
				
				_map[ info.code ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_boss.json");
			write( object );
			
			object = ConfigManager.instance.getJSONByFileName("t_boss_refresh.json");
			writeRefresh(object);
		}
		
		private function writeRefresh(obj:Object):void
		{
			var info:TBossRefresh;
			for each( var o:Object in obj  )
			{
				info = new TBossRefresh();
				info.plan = o.plan;
				info.id = o.id;
				info.bossCode = o.bossCode;
				info.mapId = o.mapId;
				_refresh[info.id] = info;
			}
		}
		
		public function getRefreshByMapId(mapId:int, isSortByPlan:Boolean=true):Array
		{
			var res:Array = [];
			for each(var info:TBossRefresh in _refresh)
			{
				if(info.mapId == mapId)
				{
					res.push(info);
				}
			}
			if(isSortByPlan)
			{
				res.sort(sortRefresh);
			}
			return res;
		}
		
		private function sortRefresh(a:TBossRefresh, b:TBossRefresh):int
		{
			if(a.plan <= b.plan)
			{
				return -1;
			}
			return 1;
		}
		
		public function getRefresById(id:int):TBossRefresh
		{
			return _refresh[id] as TBossRefresh;
		}
		
		public function getRefreshByPlan(plan:int):TBossRefresh
		{
			for each(var info:TBossRefresh in _refresh)
			{
				if(info.plan == plan)
				{
					return info;
				}
			}
			return null;
		}
		
		public function getRefreshByMapAndPlan(mapId:int, plan:int):Array
		{
			var res:Array = [];
			for each(var info:TBossRefresh in _refresh)
			{
				if(info.plan == plan && info.mapId == mapId)
				{
					res.push(info);
				}
			}
			return res;
		}
		
		/**
		 * 获取文件资源信息
		 * @param code
		 * @return
		 * 
		 */
		public function getInfoByCode( code:int ):TBoss
		{
			return _map[code];
		}
	}
}