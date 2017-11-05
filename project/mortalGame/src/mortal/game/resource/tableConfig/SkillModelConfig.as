package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TSkill;
	import Message.DB.Tables.TSkillModel;
	import Message.Public.ESkillType;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.StringHelper;
	
	import flash.utils.Dictionary;
	
	import mortal.game.cache.Cache;
	
	/**
	 * 技能 
	 * @author heartspeak
	 * t_skill.json
	 */	
	public class SkillModelConfig
	{
		private static var _instance:SkillModelConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function SkillModelConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ResConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():SkillModelConfig
		{
			if( _instance == null )
			{
				_instance = new SkillModelConfig();
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
			var info:TSkillModel;
			
			for each( var o:Object in dic  )
			{
				info = new TSkillModel();
				
				info.id = o.id;
				
				info.action = o.action;
				
				info.endAction = o.endAction;
				
				info.leadAction = o.leadAction;
				
				info.trackModel = o.trackModel;
				
				info.selfModel = o.selfModel;
				
				info.targetModel = o.targetModel;
				
				info.daoguangModel = o.daoguangModel;
				
				info.isMultiple = o.isMultiple;
				
				info.isTargetDirection = o.isTargetDirection;
				
				_map[ info.id ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object = ConfigManager.instance.getJSONByFileName("t_skill_model.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */		
		public function getInfoById( skillModelId:int ):TSkillModel
		{
			return _map[skillModelId];
		}
		
	}
}