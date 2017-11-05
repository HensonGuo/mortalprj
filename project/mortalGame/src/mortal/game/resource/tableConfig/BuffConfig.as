/**
 * @heartspeak
 * 2014-1-21 
 */   	
package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TBuff;
	import Message.DB.Tables.TSkill;
	import Message.DB.Tables.TSkillModel;
	import Message.Public.ESkillType;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.StringHelper;
	
	import flash.utils.Dictionary;
	
	import mortal.game.cache.Cache;
	import mortal.game.utils.DescUtil;
	import mortal.game.view.common.ClassTypesUtil;
	
	/**
	 * 技能 
	 * @author heartspeak
	 * t_skill.json
	 */	
	public class BuffConfig
	{
		private static var _instance:BuffConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function BuffConfig()
		{
			if( _instance != null )
			{
				throw new Error(" BuffConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():BuffConfig
		{
			if( _instance == null )
			{
				_instance = new BuffConfig();
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
			var info:TBuff;
			
			for each( var o:Object in dic  )
			{
				info = new TBuff();
				ClassTypesUtil.copyValue(info,o);
				if(info.description)
				{
					var descId:int = int(info.description);
					if(descId > 0)
					{
						info.description = DescConfig.instance.getDescAlyzObj( descId,o);
					}
				}
				_map[ info.buffId ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object = ConfigManager.instance.getJSONByFileName("t_buff.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */		
		public function getInfoById( buffId:int ):TBuff
		{
			return _map[buffId];
		}
		
	}
}