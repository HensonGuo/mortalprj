package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TEquipStrengthen;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.StringHelper;
	
	import flash.utils.Dictionary;

	public class EquipStrengthenConfig
	{
		private static var _instance:EquipStrengthenConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function EquipStrengthenConfig()
		{
			if( _instance != null )
			{
				throw new Error(" EquipStrengthenConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():EquipStrengthenConfig
		{
			if( _instance == null )
			{
				_instance = new EquipStrengthenConfig();
			}
			return _instance;
		}
		
		public var level : int;
		
		public var consumeItemCode : int;
		
		public var consumeItemAmount : int;
		
		public var consumeMoney : int;
		
		public var successProbability : int;
		
		public var mustFailedAmout : int;
		
		public var mustSuccessAmount : int;
		
		public var addPercent : int;
		
		public var rewardPercent : int;
		
		/**
		 *  
		 * @param object
		 * @return 
		 * 
		 */		
		private function write( dic:Object ):void
		{
			var info:TEquipStrengthen
			for each( var o:Object in dic  )
			{
				info = new TEquipStrengthen();
				
				info.level = o.level;
				
				info.consumeItemCode = o.consumeItemCode;
				
				info.level = o.level;
				
				info.consumeItemAmount = o.consumeItemAmount;
				
				info.consumeMoney = o.consumeMoney;
				
				info.successProbability = o.successProbability;
				
				info.mustFailedAmout = o.mustFailedAmout;
				
				info.mustSuccessAmount = o.mustSuccessAmount;
				
				info.addPercent = o.addPercent;
				
				info.rewardPercent = o.rewardPercent;
				
				_map[ info.level ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_equip_strengthen.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */
		public function getInfoByLevel( level:int ):TEquipStrengthen
		{
			return _map[level] as TEquipStrengthen;
		}
	}
}
