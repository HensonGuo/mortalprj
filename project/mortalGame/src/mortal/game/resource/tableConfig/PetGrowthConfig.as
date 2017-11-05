/**
 * @heartspeak
 * 2014-3-3 
 */   	
package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TPetConfig;
	import Message.DB.Tables.TPetGrowth;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.ObjectUtils;
	
	import flash.utils.Dictionary;
	
	import mortal.game.view.common.ClassTypesUtil;
	
	public class PetGrowthConfig
	{
		private static var _instance:PetGrowthConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function PetGrowthConfig()
		{
			if( _instance != null )
			{
				throw new Error(" PetGrowthConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():PetGrowthConfig
		{
			if( _instance == null )
			{
				_instance = new PetGrowthConfig();
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
			var info:TPetGrowth;
			//添加一条0的配置
			_map[ 0 ] = new TPetGrowth();
			for each( var o:Object in dic  )
			{
				info = new TPetGrowth();
				ClassTypesUtil.copyValue(info, o);
				_map[ info.level ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_pet_growth.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */
		public function getInfoByCode( code:int ):TPetGrowth
		{
			return _map[code] as TPetGrowth;
		}
	}
}
