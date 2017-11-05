/**
 * @heartspeak
 * 2014-1-21 
 */   	
package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TBuff;
	import Message.DB.Tables.TMoneyConfig;
	
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.game.view.common.ClassTypesUtil;
	
	/**
	 * 金钱
	 * @author heartspeak
	 * t_money_config.json
	 */	
	public class MoneyConfig
	{
		private static var _instance:MoneyConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function MoneyConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ResConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():MoneyConfig
		{
			if( _instance == null )
			{
				_instance = new MoneyConfig();
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
			var info:TMoneyConfig;
			
			for each( var o:Object in dic  )
			{
				info = new TMoneyConfig();
				ClassTypesUtil.copyValue(info,o);
				_map[ info.unit ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object = ConfigManager.instance.getJSONByFileName("t_money_config.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */
		public function getInfoByUint( uint:int ):TMoneyConfig
		{
			return _map[uint];
		}
		
	}
}