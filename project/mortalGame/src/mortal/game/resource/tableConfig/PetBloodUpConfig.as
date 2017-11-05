/**
 * @heartspeak
 * 2014-3-3 
 */   	
package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TPetBloodUp;
	import Message.DB.Tables.TPetConfig;
	import Message.DB.Tables.TPetGrowth;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.ObjectUtils;
	
	import flash.utils.Dictionary;
	
	import mortal.game.view.common.ClassTypesUtil;
	
	public class PetBloodUpConfig
	{
		private static var _instance:PetBloodUpConfig;
		
		private var _map:Dictionary = new Dictionary();
		private const CONNECT:String = "_";
		
		public function PetBloodUpConfig()
		{
			if( _instance != null )
			{
				throw new Error(" PetBloodUpConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():PetBloodUpConfig
		{
			if( _instance == null )
			{
				_instance = new PetBloodUpConfig();
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
			var info:TPetBloodUp;
			//添加一条0的配置
			for each( var o:Object in dic  )
			{
				info = new TPetBloodUp();
				ClassTypesUtil.copyValue(info, o);
				_map[ info.blood + CONNECT + info.level] = info;
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_pet_blood_up.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */
		public function getInfoByCodeLevel( code:int,level:int):TPetBloodUp
		{
			return _map[code + CONNECT + level] as TPetBloodUp;
		}
	}
}
