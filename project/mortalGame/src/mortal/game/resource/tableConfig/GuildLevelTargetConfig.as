package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TGuildLevelTarget;
	
	import com.gengine.resource.ConfigManager;
	
	import mortal.game.view.common.ClassTypesUtil;

	public class GuildLevelTargetConfig
	{
		private static var _instance:GuildLevelTargetConfig;
		private var _targetList:Vector.<TGuildLevelTarget>;
		
		public function GuildLevelTargetConfig()
		{
			if( _instance != null )
			{
				throw new Error("GuildLevelTargetConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():GuildLevelTargetConfig
		{
			if( _instance == null )
			{
				_instance = new GuildLevelTargetConfig();
			}
			return _instance;
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_guild_level_target.json");
			write( object );
		}
		
		private function write( dic:Object ):void
		{
			var info:TGuildLevelTarget;
			//添加一条0的配置
			for each( var o:Object in dic  )
			{
				info = new TGuildLevelTarget();
				ClassTypesUtil.copyValue(info, o);
				if (!_targetList)
					_targetList = new Vector.<TGuildLevelTarget>();
				_targetList.push(info);
			}
		}
		
		public function getInfoByLevel( level:int):TGuildLevelTarget
		{
			if (level - 1 >= _targetList.length)
				return null;
			return _targetList[level - 1];
		}
		
		public function getTargetList():Vector.<TGuildLevelTarget>
		{
			return _targetList;
		}
	}
}