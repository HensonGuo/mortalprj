/**
 * @heartspeak
 * 2014-3-25 
 */   	
package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TMoneyConfig;
	import Message.DB.Tables.TSysMsg;
	
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.game.view.common.ClassTypesUtil;
	
	/**
	 *  系统消息
	 * @author heartspeak
	 * t_money_config.json
	 */	
	public class SysMsgConfig
	{
		private static var _instance:SysMsgConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function SysMsgConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ResConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():SysMsgConfig
		{
			if( _instance == null )
			{
				_instance = new SysMsgConfig();
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
			var info:TSysMsg;
			
			for each( var o:Object in dic  )
			{
				info = new TSysMsg();
				ClassTypesUtil.copyValue(info,o);
				_map[ info.msgKey ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object = ConfigManager.instance.getJSONByFileName("t_sys_msg.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */
		public function getInfoByKey( msgKey:String ):TSysMsg
		{
			return _map[msgKey];
		}
		
	}
}