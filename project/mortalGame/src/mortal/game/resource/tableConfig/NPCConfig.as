package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TNpc;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.StringHelper;
	
	import flash.utils.Dictionary;
	
	import mortal.game.view.common.ClassTypesUtil;

	public class NPCConfig
	{
		
		private static var _instance:NPCConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function NPCConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ResConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():NPCConfig
		{
			if( _instance == null )
			{
				_instance = new NPCConfig();
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
			var info:TNpc;
			
			for each( var o:Object in dic  )
			{
				info = new TNpc();
				ClassTypesUtil.copyValue(info, o);
				_map[ info.code ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_npc.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */		
		public function getInfoByCode( npcID:int ):TNpc
		{
			return _map[npcID];
		}
	}
}
