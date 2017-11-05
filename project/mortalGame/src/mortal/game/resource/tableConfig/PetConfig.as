package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TPetConfig;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.StringHelper;
	
	import flash.utils.Dictionary;

	public class PetConfig
	{
		private static var _instance:PetConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function PetConfig()
		{
			if( _instance != null )
			{
				throw new Error(" PetConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():PetConfig
		{
			if( _instance == null )
			{
				_instance = new PetConfig();
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
			var info:TPetConfig;
			for each( var o:Object in dic  )
			{
				info = new TPetConfig();
				
				info.code = o.code;
				
				info.name = o.name;
				
				info.level = o.level;
				
				info.type = o.type;
				
				info.model = o.model;
				
				info.avatar = o.avatar;
				
				info.growth = o.growth;
				
				info.talent = o.talent;
				
				info.talentMax = o.talentMax;
				
				info.skill1 = o.skill1;
				
				info.skill2 = o.skill2;
				
				info.skill3 = o.skill3;
				
				_map[ info.code ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_pet_config.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */
		public function getInfoByCode( code:int ):TPetConfig
		{
			return _map[code] as TPetConfig;
		}
	}
}
