package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TEquipJewelMatch;
	
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;

	/**
	 * @date   2014-4-2 下午2:22:05
	 * @author dengwj
	 */	 
	public class EquipJewelMatchConfig
	{
		private static var _instance:EquipJewelMatchConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function EquipJewelMatchConfig()
		{
			if( _instance != null )
			{
				throw new Error(" EquipJewelMatchConfig 单例 ");
			}
			init();
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_equip_jewel_match.json");
			write( object );
		}
		
		public static function get instance():EquipJewelMatchConfig
		{
			if( _instance == null )
			{
				_instance = new EquipJewelMatchConfig();
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
			var info:TEquipJewelMatch;
			for each( var o:Object in dic  )
			{
				info = new TEquipJewelMatch();
				
				info.equiptype = o.equiptype;
				
				info.jeweltype = o.jeweltype;
				
				info.desc = o.desc;
				
				
				_map[ info.equiptype ] = info;
			}
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */
		public function getInfoByType( equipType:int ):TEquipJewelMatch
		{
			return _map[equipType] as TEquipJewelMatch;
		}
		
		/**
		 * 根据宝石类型得装备类型 
		 * @return 
		 */		
		public function getEquipTypeByJewelType(jewelType:int):Array
		{
			var resultArr:Array = [];
			for each(var matchInfo:TEquipJewelMatch in _map)
			{
				if(matchInfo.jeweltype == jewelType)
				{
					resultArr.push(matchInfo.equiptype);
				}
			}
			return resultArr;
		}
	}
}